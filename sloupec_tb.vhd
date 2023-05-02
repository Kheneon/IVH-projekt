--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:39:07 05/07/2022
-- Design Name:   
-- Module Name:   /home/kheneon/Codes/IVH/sloupec_tb.vhd
-- Project Name:  proj
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: sloupec
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY sloupec_tb IS
END sloupec_tb;
 
ARCHITECTURE behavior OF sloupec_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT sloupec
    PORT(
         CLK : IN  std_logic;
         RESET : IN  std_logic;
         STATE : OUT  std_logic_vector(7 downto 0);
         INIT_STATE : IN  std_logic_vector(7 downto 0);
         NEIGH_LEFT : IN  std_logic_vector(7 downto 0);
         NEIGH_RIGHT : IN  std_logic_vector(7 downto 0);
         DIRECTION : IN  std_logic;
         EN : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal INIT_STATE : std_logic_vector(7 downto 0) := (others => '1');
   signal NEIGH_LEFT : std_logic_vector(7 downto 0) := "00001111";
   signal NEIGH_RIGHT : std_logic_vector(7 downto 0) := "11110000";
   signal DIRECTION : std_logic := '0';
   signal EN : std_logic := '0';

 	--Outputs
   signal STATE : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: sloupec PORT MAP (
          CLK => CLK,
          RESET => RESET,
          STATE => STATE,
          INIT_STATE => INIT_STATE,
          NEIGH_LEFT => NEIGH_LEFT,
          NEIGH_RIGHT => NEIGH_RIGHT,
          DIRECTION => DIRECTION,
          EN => EN
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      RESET <= '1';
		
		wait for 100 ns;	
		RESET <= '0';
		wait for CLK_PERIOD;
		EN <= '1';
		wait for CLK_PERIOD;
		EN <= '0';
		wait for CLK_PERIOD*16;
		DIRECTION <= '1';
		wait for CLK_PERIOD;
		EN <= '1';
		wait for CLK_PERIOD;
		EN <= '0';
		wait for CLK_PERIOD*16;
		RESET <= '1';
		wait for CLK_PERIOD;
		RESET <= '0';
		

      -- insert stimulus here 

      wait;
   end process;

END;
