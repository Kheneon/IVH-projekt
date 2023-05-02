--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:24:10 05/05/2022
-- Design Name:   
-- Module Name:   /home/kheneon/Codes/IVH/rom_tb.vhd
-- Project Name:  proj
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: rom
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY rom_tb IS
END rom_tb;
 
ARCHITECTURE behavior OF rom_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT rom
    PORT(
         address : IN  std_logic_vector(3 downto 0);
         data : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal address : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal data : std_logic_vector(7 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: rom PORT MAP (
          address => address,
          data => data
        );
 

   -- Stimulus process
   stim_proc: process
   variable add_pos : std_logic_vector(3 downto 0) := "0000";
	begin		
      -- hold reset state for 100 ns.
		wait for 100 ns;	
		address <= "0000";
		
			for i in 0 to 15 loop
				address <= address + 1;
				wait for 10*CLK_period;
			end loop;
      -- insert stimulus here 

      wait;
   end process;

END;
