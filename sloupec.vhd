----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
library work;

entity sloupec is
	 Port ( CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           STATE : out  STD_LOGIC_VECTOR(7 downto 0);
           INIT_STATE : in  STD_LOGIC_VECTOR(7 downto 0);
           NEIGH_LEFT : in  STD_LOGIC_VECTOR(7 downto 0);
           NEIGH_RIGHT : in  STD_LOGIC_VECTOR(7 downto 0);
           DIRECTION : in  std_logic; -- 0 is right, 1 left
           EN : in  STD_LOGIC);
end sloupec;

architecture Behavioral of sloupec is
	
	signal save_vector : std_logic_vector(7 downto 0);
	
begin
	process (CLK)
	begin
		if rising_edge(CLK) then
			-- RESET is used for storing data from INIT_STATE
			if RESET = '1' then
				save_vector <= INIT_STATE;
			else
				if EN = '1' then
					-- Storing data from directions, depends of DIRECTION = 1/0
					if DIRECTION = '0' then
						save_vector <= NEIGH_RIGHT;
					elsif DIRECTION = '1' then
						save_vector <= NEIGH_LEFT;
					end if;
				end if;
			end if;
		end if;
		STATE <= save_vector;
	end process;

end Behavioral;

