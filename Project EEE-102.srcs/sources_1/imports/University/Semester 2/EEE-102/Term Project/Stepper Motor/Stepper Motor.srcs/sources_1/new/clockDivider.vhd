library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity clockDivider is
    Port ( clk_in : in STD_LOGIC;
           clk_out : out STD_LOGIC;
           clk_1 : out STD_LOGIC;
           clk_box : out STD_LOGIC);
end clockDivider;

architecture Behavioral of clockDivider is
signal count : STD_LOGIC_VECTOR( 27 downto 0);

begin

process( clk_in)                       --clock divider
begin
    if rising_edge( clk_in) then         
        count <= count + 1;
    end if;
end process;

clk_out <= count(15);
clk_1 <= count(26);
clk_box <= count(15);
end Behavioral;
