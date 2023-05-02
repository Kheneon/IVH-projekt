-------------------------
-- IVH 2022 - FSM
--
-- Name: Michal Zapletal
-- Login: xzaple41
--
-------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
library work;
--use work.cnt_for_n.all;

entity fsm is
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
			  COLUMN : out std_logic_vector(3 downto 0);
			  COL_VECTOR : out std_logic_vector(7 downto 0)
			  );
end fsm;

architecture Behavioral of fsm is
			
	-- Signals for component SLOUPEC
	signal RESET_SLOUPEC : std_logic := '1';
	signal STATE : std_logic_vector(7 downto 0) := (others => '0');
	signal INIT_STATE : std_logic_vector(7 downto 0) := (others => '0');
	signal DIRECTION : std_logic := '0';

	-- Signals for ROM
	signal address : std_logic_vector (3 downto 0) := "0000";
	signal data : std_logic_vector (7 downto 0);
	
	-- Signals for FSM
	type STATE_T is (st1_reset, st2_initialize, st3_right_dir, st4_left_dir, st5_animation, st6_reloading); 
   signal state_act : STATE_T;
	signal load_rom_en : std_logic := '0'; -- set to 1 if want to load data from ROM
	
	-- Signal for reloading display (process "pos_change")
	signal pos : std_logic_vector(3 downto 0) := "0000";
	
	-- Signal for storing vector
	signal vector_map_init : std_logic_vector (127 downto 0);
	signal vector_map_output : std_logic_vector (127 downto 0);
	
	-- Signals for counters
		-- Counter 1 "Display Reload"      -- Reloading display
	signal cnt_1_en : std_logic := '1';
	signal display_reload : std_logic;
		-- Counter 2 "Move columns"        -- Changing content on display
	signal cnt_2_en : std_logic;
	signal cnt_move_col_en : std_logic;
		-- Counter 3 "Chessboard"          -- wait for loading chessboard on display
	signal cnt_3_en : std_logic;
	signal cnt_3_done : std_logic;
		-- Counter 4 "Timer"               -- Time before next cycle
	signal cnt_timer_done : std_logic;
	signal cnt_timer_en : std_logic;
		-- Counter 5 "Move columns counter -- Cycle timer
	signal move_en : std_logic;
	signal cycle_done : std_logic := '0';
	
	component sloupec is
		Port ( CLK : in  STD_LOGIC;                         -- Clock
           RESET : in  STD_LOGIC;                         -- Reset for loading into SLOUPEC data od INIT_STATE
           STATE : out  STD_LOGIC_VECTOR(7 downto 0);     -- Output of std_logic_vector
           INIT_STATE : in  STD_LOGIC_VECTOR(7 downto 0); -- Combine with RESET to store data into SLOUPEC
           NEIGH_LEFT : in  STD_LOGIC_VECTOR(7 downto 0); -- Column on the left from itself
           NEIGH_RIGHT : in  STD_LOGIC_VECTOR(7 downto 0);-- Column on the right from itself
           DIRECTION : in  std_logic;                     -- 0 is left, 1 is right
           EN : in  STD_LOGIC                             -- Enable to move in direction (Right or left)
			  );
	end component;

	-- COL index of column we want to position, NUM_OF_COLS is real number of columns
	-- !!! Not original GETCOLUMN FUNCTION !!!
	function GETCOLUMN (COL : in integer; NUM_OF_COLS : in integer)
		return integer is
		variable position : integer;
	begin
		if COL < 0 then
			position := NUM_OF_COLS;
		elsif COL >= NUM_OF_COLS then
			position := 1;
		else
			position := COL+1;
		end if;
		return position;
	end;
	
	-- ROM component
	component rom is
		port(
			address : in std_logic_vector(3 downto 0);
			data : out std_logic_vector(7 downto 0)
			);
	end component;
	
	-- COUNTER_48 component
	component counter_48 is
		port(
			CLK : in std_logic;
			CNT_EN : in std_logic;
			CNT_DONE : out std_logic
			);
	end component;
	
	-- Counter for N bits
	component cnt_for_n is
		generic(N : in integer);
		port(
			CLK : in std_logic;
			CNT_CYCLE : out std_logic;
			CNT_EN : in std_logic
			);
	end component;
	
begin
	-- Preset values of counters, when active or inactive
	cnt_2_en <= '1' when state_act = st3_right_dir or state_act = st4_left_dir else '0';
	cnt_3_en <= '1' when state_act = st5_animation else '0';
	cnt_timer_en <= '1' when state_act = st6_reloading else '0';
	
	rom_map : rom
		port map(
			address => address,
			data => data
			);
	
	counter_to_48 : entity work.counter_48
		port map(
			CLK => CLK,
			CNT_EN => move_en,
			CNT_DONE => cycle_done
			);
			
	-- Frequency = ( number of CLK cycles / number of columns ) / my needed FPS frequency
	--
	-- Frequency = (25 000 000 / 16 ) / 200
	--           =      ( 1 562 500 ) / 200
	--           = 7812 cycles
	--
	-- That means counter with +- 13 bites
	-- Setting frequence of reloading display
	counter1 : entity work.cnt_for_n
		generic map( N => 13)
		port map(
			CLK => CLK,
			CNT_CYCLE => display_reload,
			CNT_EN => cnt_1_en
			);
			
	-- Frequency = 25MHz / 2^(NUMBER OF BITS)
	-- move R/L every second
	-- 0,74Hz frequency has 25 bites
	-- 1,49Hz frequency has 24 bites
	-- Did not select frequency just from counting it.
	-- Ideal for me was 23bits counter, which means frequency = 2,98Hz
	counter2 : entity work.cnt_for_n
		generic map( N => 23)
		port map(
			CLK => CLK,
			CNT_CYCLE => cnt_move_col_en,
			CNT_EN => cnt_2_en
			);
			
	-- counter for loading animation
	counter3 : entity work.cnt_for_n
		generic map( N => 4)
		port map(
			CLK => CLK,
			CNT_CYCLE => cnt_3_done,
			CNT_EN => cnt_3_en
			);
	
	-- Timer before next cycle
	counter_timer : entity work.cnt_for_n
		generic map( N => 26)
		port map(
			CLK => CLK,
			CNT_CYCLE => cnt_timer_done,
			CNT_EN => cnt_timer_en
			);
	
	-- for-generate generates connections
	sloupce_gen:
	for i in 0 to 15 generate
		sloupce : sloupec
			port map(
				CLK => CLK,
				RESET => RESET_SLOUPEC,
				INIT_STATE => vector_map_init((i+1)*8-1 downto i*8),
				--
				STATE => vector_map_output((i+1)*8-1 downto i*8),
				--
				NEIGH_LEFT => vector_map_init(GETCOLUMN(i-1,16)*8-1 downto ( GETCOLUMN(i-1,16)-1 )*8),
				NEIGH_RIGHT => vector_map_init(GETCOLUMN(i+1,16)*8-1 downto ( GETCOLUMN(i+1,16)-1 )*8),
				DIRECTION => DIRECTION,
				EN => move_en
			);
	end generate sloupce_gen;
	
	-- Mapping vectors
	COLUMN <= pos;
	COL_VECTOR <= vector_map_output((to_integer(unsigned(pos))+1)*8-1 downto to_integer(unsigned(pos))*8);
	
	-- Loading from ROM into SLOUPEC
	--
	-- If we want to load again into SLOUPEC data from ROM, just set RESET_SLOUPEC to 1
	load_rom : process (CLK)
	variable loaded_col : std_logic_vector(3 downto 0) := "0001";
	begin
		if rising_edge(CLK) then
			if load_rom_en = '1' then
				address <= loaded_col;
				vector_map_init((to_integer(unsigned(loaded_col-1))+1)*8-1 downto to_integer(unsigned(loaded_col-1))*8) <= data;
				if loaded_col = "0000" then
					RESET_SLOUPEC <= '0';
					loaded_col := loaded_col + 1;
				else
					loaded_col := loaded_col + 1;
				end if;
			end if;
			
			-- Moving vector to right or left
			if state_act = st3_right_dir or state_act = st4_left_dir then
				if move_en = '1' then
					if DIRECTION = '0' then -- RIGHT
						vector_map_init <= vector_map_init(119 downto 0) & vector_map_init(127 downto 120);
					elsif DIRECTION = '1' then -- LEFT
						vector_map_init <= vector_map_init(7 downto 0) & vector_map_init(127 downto 8);
					end if;
					RESET_SLOUPEC <= '1';
				else
					RESET_SLOUPEC <= '0';
				end if;
			end if;
			
			-- Loading animation
			if state_act = st5_animation then
				if vector_map_init(0) = '0' then
					vector_map_init <= vector_map_init(119 downto 0) & "01010101";
				elsif vector_map_init(0) = '1' then
					vector_map_init <= vector_map_init(119 downto 0) & "10101010";
				end if;
				if cnt_3_done = '1' then
					RESET_SLOUPEC <= '1';
				end if;
			end if;
		end if;
	end process;
	
	-- Reloading display
	pos_change : process (CLK)
	begin
		if rising_edge(CLK) then
			if display_reload = '1' then
				pos <= pos + 1;
			end if;
		end if;
	end process;
	
	-- FSM
	fsm : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST = '1' then
				state_act <= st1_reset;
			else
				case state_act is
					
					-- reset state, do nothing until RESET = 0
					when st1_reset =>
						if RST = '0' then
							load_rom_en <= '1';
							state_act <= st2_initialize;
						end if;
					
					-- Initialize display
					when st2_initialize =>
						if RESET_SLOUPEC = '0' then
							load_rom_en <= '0';
							state_act <= st3_right_dir;
						end if;
					
					-- Right direction
					when st3_right_dir =>
						if cnt_move_col_en = '1' then
							move_en <= '1';
						else
							move_en <= '0';
						end if;
						if cycle_done = '1' then
							DIRECTION <= '1';
							state_act <= st4_left_dir;
						end if;
						
					-- Left direction
					when st4_left_dir =>
						if cnt_move_col_en = '1' then
							move_en <= '1';
						else
							move_en <= '0';
						end if;
						if cycle_done = '1' then
							DIRECTION <= '0';
							state_act <= st5_animation;
						end if;
					
					-- Loading animation
					when st5_animation =>
						if cnt_3_done = '1' then
							state_act <= st6_reloading;
						end if;
						
					-- Just showing chessboard for about 2 seconds
					when st6_reloading =>
						if cnt_timer_done = '1' then
							state_act <= st1_reset;
						end if;
					
					when others =>
						state_act <= st1_reset;
				end case;
			end if;
		end if;
	end process;
	
end Behavioral;

