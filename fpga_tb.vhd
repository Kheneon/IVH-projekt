--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:34:50 05/07/2022
-- Design Name:   
-- Module Name:   /home/kheneon/Codes/IVH/fpga_tb.vhd
-- Project Name:  proj
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: tlv_gp_ifc
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
 
ENTITY fpga_tb IS
END fpga_tb;
 
ARCHITECTURE behavior OF fpga_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT tlv_gp_ifc
    PORT(
         SMCLK : IN  std_logic;
         ACLK : IN  std_logic;
         FCLK : IN  std_logic;
         CLK : IN  std_logic;
         RESET : IN  std_logic;
         IRQ : OUT  std_logic;
         LEDF : OUT  std_logic;
         SPI_CS : IN  std_logic;
         SPI_DI : OUT  std_logic;
         SPI_DI_REQ : IN  std_logic;
         SPI_DO : IN  std_logic;
         SPI_DO_VLD : IN  std_logic;
         KIN : OUT  std_logic_vector(3 downto 0);
         KOUT : IN  std_logic_vector(3 downto 0);
         LE : OUT  std_logic;
         LRS : OUT  std_logic;
         LRW : OUT  std_logic;
         LD : INOUT  std_logic_vector(7 downto 0);
         RA : OUT  std_logic_vector(14 downto 0);
         RD : INOUT  std_logic_vector(7 downto 0);
         RDQM : OUT  std_logic;
         RCS : OUT  std_logic;
         RRAS : OUT  std_logic;
         RCAS : OUT  std_logic;
         RWE : OUT  std_logic;
         RCLK : OUT  std_logic;
         RCKE : OUT  std_logic;
         P3M : INOUT  std_logic_vector(7 downto 0);
         AFBUS : INOUT  std_logic_vector(11 downto 0);
         X : INOUT  std_logic_vector(45 downto 6);
         ALRCIN : INOUT  std_logic;
         ADIN : OUT  std_logic;
         ALRCOUT : INOUT  std_logic;
         ADOUT : IN  std_logic;
         ABCLK : INOUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal SMCLK : std_logic := '0';
   signal ACLK : std_logic := '0';
   signal FCLK : std_logic := '0';
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal SPI_CS : std_logic := '0';
   signal SPI_DI_REQ : std_logic := '0';
   signal SPI_DO : std_logic := '0';
   signal SPI_DO_VLD : std_logic := '0';
   signal KOUT : std_logic_vector(3 downto 0) := (others => '0');
   signal ADOUT : std_logic := '0';

	--BiDirs
   signal LD : std_logic_vector(7 downto 0);
   signal RD : std_logic_vector(7 downto 0);
   signal P3M : std_logic_vector(7 downto 0);
   signal AFBUS : std_logic_vector(11 downto 0);
   signal X : std_logic_vector(45 downto 6);
   signal ALRCIN : std_logic;
   signal ALRCOUT : std_logic;
   signal ABCLK : std_logic;

 	--Outputs
   signal IRQ : std_logic;
   signal LEDF : std_logic;
   signal SPI_DI : std_logic;
   signal KIN : std_logic_vector(3 downto 0);
   signal LE : std_logic;
   signal LRS : std_logic;
   signal LRW : std_logic;
   signal RA : std_logic_vector(14 downto 0);
   signal RDQM : std_logic;
   signal RCS : std_logic;
   signal RRAS : std_logic;
   signal RCAS : std_logic;
   signal RWE : std_logic;
   signal RCLK : std_logic;
   signal RCKE : std_logic;
   signal ADIN : std_logic;

   -- Clock period definitions
   constant SMCLK_period : time := 10 ns;
   constant ACLK_period : time := 10 ns;
   constant FCLK_period : time := 10 ns;
   constant CLK_period : time := 10 ns;
   constant RCLK_period : time := 10 ns;
   constant ABCLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: tlv_gp_ifc PORT MAP (
          SMCLK => SMCLK,
          ACLK => ACLK,
          FCLK => FCLK,
          CLK => CLK,
          RESET => RESET,
          IRQ => IRQ,
          LEDF => LEDF,
          SPI_CS => SPI_CS,
          SPI_DI => SPI_DI,
          SPI_DI_REQ => SPI_DI_REQ,
          SPI_DO => SPI_DO,
          SPI_DO_VLD => SPI_DO_VLD,
          KIN => KIN,
          KOUT => KOUT,
          LE => LE,
          LRS => LRS,
          LRW => LRW,
          LD => LD,
          RA => RA,
          RD => RD,
          RDQM => RDQM,
          RCS => RCS,
          RRAS => RRAS,
          RCAS => RCAS,
          RWE => RWE,
          RCLK => RCLK,
          RCKE => RCKE,
          P3M => P3M,
          AFBUS => AFBUS,
          X => X,
          ALRCIN => ALRCIN,
          ADIN => ADIN,
          ALRCOUT => ALRCOUT,
          ADOUT => ADOUT,
          ABCLK => ABCLK
        );

   -- Clock process definitions
   SMCLK_process :process
   begin
		SMCLK <= '0';
		wait for SMCLK_period/2;
		SMCLK <= '1';
		wait for SMCLK_period/2;
   end process;
 
   ACLK_process :process
   begin
		ACLK <= '0';
		wait for ACLK_period/2;
		ACLK <= '1';
		wait for ACLK_period/2;
   end process;
 
   FCLK_process :process
   begin
		FCLK <= '0';
		wait for FCLK_period/2;
		FCLK <= '1';
		wait for FCLK_period/2;
   end process;
 
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 
   RCLK_process :process
   begin
		RCLK <= '0';
		wait for RCLK_period/2;
		RCLK <= '1';
		wait for RCLK_period/2;
   end process;
 
   ABCLK_process :process
   begin
		ABCLK <= '0';
		wait for ABCLK_period/2;
		ABCLK <= '1';
		wait for ABCLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for SMCLK_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
