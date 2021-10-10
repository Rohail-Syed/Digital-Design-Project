library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity StepModule is
    Port ( clk : in STD_LOGIC;
           dir : in STD_LOGIC_VECTOR( 1 downto 0);
           step : out STD_LOGIC_VECTOR( 3 downto 0));
end StepModule;

architecture Behavioral of StepModule is

signal cwstepp : STD_LOGIC_VECTOR( 3 downto 0);
signal acwstepp : STD_LOGIC_VECTOR( 3 downto 0);
signal counter : STD_LOGIC_VECTOR( 2 downto 0);
signal startCnt : integer := 0;
signal lastState : STD_LOGIC;

begin
process( clk, dir)  
   begin
   if ( rising_edge(clk)) then
   if ( startCnt = 880) then
     counter <= counter;
     if( lastState /= dir(1)) then
             startCnt <= 0;
             else
             startCnt <= startCnt;
             end if;
      else
   if (dir = "01") then
     counter <= counter + 1;
     startCnt <= startCnt + 1;
     lastState <= dir(1);
     elsif(dir = "11") then
     counter <= counter + 1;
     startCnt <= startCnt + 1;
     lastState <= dir(1); 
     else counter <= counter;
     end if;
     end if;
     end if;
     
  end process;

process( cwstepp, counter)
begin
        case counter is
            when "000" => cwstepp <= "0001";
            when "001" => cwstepp <= "0011";
            when "010" => cwstepp <= "0010";
            when "011" => cwstepp <= "0110";
            when "100" => cwstepp <= "0100";
            when "101" => cwstepp <= "1100";
            when "110" => cwstepp <= "1000";
            when others => cwstepp <= "1001";
        end case;
end process;

process( acwstepp, counter)
begin
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
end process;

process( dir)
begin
if dir = "01" then
    step <= acwstepp;
    elsif dir = "11" then
    step <= cwstepp;
    elsif ((dir = "10") or (dir = "00")) then
    step <= "0000";
end if;
end process;

end Behavioral;
