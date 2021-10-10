library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity conveyor is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           belt : out STD_LOGIC_VECTOR (3 downto 0));
end conveyor;

architecture Behavioral of conveyor is
signal counter : STD_LOGIC_VECTOR(2 downto 0);
signal acwstepp : STD_LOGIC_VECTOR(3 downto 0);

begin

process(clk)
begin
    if rising_edge(clk) then
        counter <= counter + 1;
    end if;
end process;

process( acwstepp, counter, reset)
begin
if reset = '1' then
    acwstepp <= "0000";
    else
        case counter is
            when "000" => acwstepp <= "1000";
            when "001" => acwstepp <= "1100";
            when "010" => acwstepp <= "0100";
            when "011" => acwstepp <= "0110";
            when "100" => acwstepp <= "0010";
            when "101" => acwstepp <= "0011";
            when "110" => acwstepp <= "0001";
            when others => acwstepp <= "1001";
        end case;
    end if;
end process;

belt <= acwstepp;
end Behavioral;
