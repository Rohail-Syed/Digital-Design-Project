library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Trigger_generator is
    Port ( clk : in STD_LOGIC;
           Trigger : out STD_LOGIC);
end Trigger_generator;

architecture Behavioral of Trigger_generator is

component counter is
generic(n: POSITIVE := 10);
Port ( clk : in STD_LOGIC;
       enable : in STD_LOGIC;
       reset : in STD_LOGIC;
       counter_output : out STD_LOGIC_VECTOR (n-1 downto 0));
end component;

signal resetCounter : STD_LOGIC;
signal outputCounter : STD_LOGIC_VECTOR(24 downto 0);
    
begin

trigg: Counter generic  map(25) PORT MAP(
clk => clk,
enable => '1',
reset => resetCounter,
counter_output => outputCounter);

process(clk)
constant  ms250 : STD_LOGIC_VECTOR( 24 downto 0) := "1011111010111100001000000";
constant ms250and100us : STD_LOGIC_VECTOR( 24 downto 0) := "1011111100000101011110100";

begin
    if(outputcounter > ms250 and outputCounter < ms250and100us) then 
        trigger <= '1';
    else
        trigger <= '0';
    end if;
        if(outputcounter = ms250and100us or outputcounter = "XXXXXXXXXXXXXXXXXXXXXXXX") then
            resetcounter <= '0';
        else
            resetcounter <= '1';
        end if;
end process;

end Behavioral;
