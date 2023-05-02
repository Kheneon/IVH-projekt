-------------------------
-- IVH 2022 - cnt_for_n
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

entity cnt_for_n is
    generic (N : integer := 10);
	 Port ( CLK : in  STD_LOGIC;
           CNT_CYCLE : out  STD_LOGIC;
			  CNT_EN : in std_logic);
end cnt_for_n;

-- Counter for N bits
-- "N" means number of bits
architecture Behavioral of cnt_for_n is
	
signal counter : std_logic_vector (N-1 downto 0) := (others => '0');
signal counter_done : std_logic_vector (N-1 downto 0) := (others => '1');
	
begin
	cnt : process
	begin
		if rising_edge(clk) then
			if CNT_EN = '1' then
				counter <= counter + 1;
				if counter = counter_done then
					CNT_CYCLE <= '1';
					counter <= (others => '0');
				else
					CNT_CYCLE <= '0';
				end if;
			else
				CNT_CYCLE <= '0';
				counter <= (others => '0');
			end if;
		end if;
	end process;

end Behavioral;

