library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
      
entity counter is
    generic(n: POSITIVE := 10);
    Port ( clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           reset : in STD_LOGIC;
           counter_output : out STD_LOGIC_VECTOR (n-1 downto 0));
    end counter;
    
architecture Behavioral of counter is
signal count :  STD_LOGIC_VECTOR(n-1 downto 0);

begin

process (clk, reset)
begin 
    if (reset = '0') then
        count <= ( others => '0');
    elsif(clk'event and  clk = '1') then
        if (enable = '1') then 
            count <=  count + 1;
        end if;   
    end if;
end process;

counter_output <= count;
end Behavioral;
