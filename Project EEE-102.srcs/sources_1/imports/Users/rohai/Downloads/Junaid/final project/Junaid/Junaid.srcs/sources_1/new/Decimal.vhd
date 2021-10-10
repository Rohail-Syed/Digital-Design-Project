library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.std_logic_unsigned.all;

entity Decimal is
    Port ( distance_in : in STD_LOGIC_VECTOR (8 downto 0);
           Decimal_Out0 : out integer range 0 to 9;
           Decimal_Out1 : out integer range 0 to 9;
          Decimal_Out2 : out  integer range 0 to 9);
end Decimal;

architecture Behavioral of Decimal is
signal Distance : integer range 0 to 512 ;

begin

process(distance_in , Distance) 
begin 
    Distance <= conv_integer(distance_in)/2 ;
    Decimal_Out0 <= Distance mod 10 ;
    Decimal_Out1 <= (Distance  / 10 ) mod 10 ;
    Decimal_Out2 <= Distance / 100 ;
end Process ;

end Behavioral;
