library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Distance_Calculation is
    Port ( clk : in STD_LOGIC;
           calculation_reset : in STD_LOGIC;
           pulse : in STD_LOGIC;
           distance : out STD_LOGIC_VECTOR (8 downto 0));
end Distance_Calculation;

architecture Behavioral of Distance_Calculation is

component counter is
generic(n: POSITIVE := 10);
Port ( clk : in STD_LOGIC;
       enable : in STD_LOGIC;
       reset : in STD_LOGIC;
       counter_output : out STD_LOGIC_VECTOR (n-1 downto 0));
end component;

signal pulse_width : STD_LOGIC_VECTOR(21 downto 0);
signal calculation_reset_signal :  STD_LOGIC;

begin

calculation_reset_signal <= not calculation_reset;

counterpulse: counter  generic  map(22) PORT MAP(
clk => clk ,
enable => pulse,
reset =>  calculation_reset_signal,
counter_output => pulse_width);
   
Distance_calculation: process(pulse)

variable Result : integer;
variable multiplier : STD_LOGIC_VECTOR(23 downto 0);

begin  
    if(pulse = '0') then 
        multiplier := pulse_width* "11";
        Result := to_integer(unsigned(multiplier(23 downto 13)));
    if(result > 458) then 
        distance <= "111111111";
    else
        distance <= STD_LOGIC_VECTOR(to_unsigned(Result,9));
    end if;
    end if;
    end  process  Distance_calculation;
end Behavioral;