library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity BoxSensor is
    Port ( clk : in STD_LOGIC;
           Decimal0 : in integer;
           Decimal1 : in integer;
           Decimal2 : in integer;
           boxes : out STD_LOGIC_VECTOR (2 downto 0));
end BoxSensor;

architecture Behavioral of BoxSensor is
signal Distance : integer;
signal count : STD_LOGIC_VECTOR(2 downto 0) := "000";
signal currentState : STD_LOGIC := '0';
signal previousState : STD_LOGIC := '0';

component Decoder is
    Port ( count : in STD_LOGIC_VECTOR (2 downto 0);
           boxes : out STD_LOGIC_VECTOR (6 downto 0));
end component;

begin

process(clk)
begin
    if (Distance = 009 OR Distance = 008 OR Distance = 007 OR Distance = 006 OR Distance = 005 OR Distance = 004 OR Distance = 003) then
        currentState <= '1';
    elsif (Distance = 018 OR Distance = 017 OR Distance = 016 OR Distance = 015 OR Distance = -2147483648) then
        currentState <= '0';
    end if;
end process;

process(currentState, previousState) is
begin
    if (currentState /= previousState) then
        if currentState = '1' then
            count <= count + 1;
        else count <= count;
        end if;
    end if;
end process;

--Decode : Decoder PORT MAP(
--count => count,
--boxes => boxes);
boxes <= count;
Distance <= (Decimal0 * 100) + (Decimal1 * 10) + (Decimal2);
end Behavioral;
