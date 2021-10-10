library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity TopModule_main_tb is
end;

architecture bench of TopModule_main_tb is

  component TopModule_main
      Port ( clk : in STD_LOGIC;
             pulse : in STD_LOGIC;
             triggerout : out STD_LOGIC;
             SSEG_AN  : out STD_LOGIC_VECTOR (3 downto 0);
             SSEG_CA  : out STD_LOGIC_VECTOR (6 downto 0);
             step : out STD_LOGIC_VECTOR( 3 downto 0));
  end component;

  signal clk: STD_LOGIC;
  signal pulse: STD_LOGIC;
  signal triggerout: STD_LOGIC;
  signal SSEG_AN: STD_LOGIC_VECTOR (3 downto 0);
  signal SSEG_CA: STD_LOGIC_VECTOR (6 downto 0);
  signal step: STD_LOGIC_VECTOR( 3 downto 0);
  
  constant clk_period : time := 10ns;

begin

  uut: TopModule_main port map ( clk        => clk,
                                 pulse      => pulse,
                                 triggerout => triggerout,
                                 SSEG_AN    => SSEG_AN,
                                 SSEG_CA    => SSEG_CA,
                                 step       => step );
  clocking : process
  begin
   clk <= '0';
   wait for clk_period/2;
   clk <= '1';
   wait for clk_period/2;  
  end process;

  stimulus: process
  begin
  
    -- Put initialisation code here
triggerout <= '0';
wait for 100ms;
triggerout <= '1';
wait for 100ms;
triggerout <= '0';
wait for 100ms;

    -- Put test bench stimulus code here
  end process;


end;