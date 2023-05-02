-------------------------
-- IVH 2022 - ROM
--
-- Name: Michal Zapletal
-- Login: xzaple41
--
-------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
library work;

entity rom is
    Port ( address : in  STD_LOGIC_VECTOR(3 downto 0);
           data : out  STD_LOGIC_VECTOR(7 downto 0));
end rom;

architecture Behavioral of rom is

type rom_array is array (0 to 15) of std_logic_vector(7 downto 0);

-- In memory is loaded symbol of VUT and "FIT"
constant rom: rom_array := 
	("01111110", "01111010", "01111010", "01000110",
	 "01110110", "01111110", "00000000", "01111110",
	 "00010010", "00000000", "01111110", "00000000",
	 "00000010", "01111110", "00000010", "00000000");
-------------------- 
--|                |
--|XXXXXX XX X XXX |
--|X  XXX X  X  X  |
--|XXX  X X  X  X  |
--|XXX XX XX X  X  |
--|XXX XX X  X  X  |
--|XXXXXX X  X  X  |
--|                |
--------------------
begin
	data <= rom(to_integer(unsigned(address)));
end Behavioral;

