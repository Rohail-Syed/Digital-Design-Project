library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.std_logic_unsigned.all;

entity clockModule is
    Port ( clk : in STD_LOGIC;
           clk7out : out STD_LOGIC ;
           clk10out : out STD_LOGIC ;
           clk4out : out STD_LOGIC ;
           clk240out : out STD_LOGIC);
end clockModule;

architecture Behavioral of clockModule is
signal counter7Hz : integer range 0 to 7142857;
signal clk7Hzwire : STD_LOGIC;
signal counter10Hz : integer range 0 to 5000000;
signal clk10Hzwire : STD_LOGIC;
signal counter4Hz : integer range 0 to 12500000;
signal clk4Hzwire : STD_LOGIC;
signal counter240Hz : integer range 0 to 208333;
signal clk240Hzwire : STD_LOGIC;

begin

process (clk)
begin 
if rising_edge(clk)  then 
    if counter7Hz < 7142857 then 
       counter7Hz <= counter7Hz + 1 ;
    else 
        clk7Hzwire <= not clk7Hzwire ;
        counter7Hz <= 0  ;
    end if ;
end if ;
end process ;

process (clk)
begin 
if rising_edge(clk)  then 
    if counter10Hz < 5000000 then 
       counter10Hz <= counter10Hz + 1 ;
    else 
        clk10Hzwire <= not clk10Hzwire ;
        counter10Hz <= 0  ;
    end if ;
end if ;
end process ;

process (clk)
begin 
if rising_edge(clk)  then 
    if counter4Hz < 12500000 then 
       counter4Hz <= counter4Hz + 1 ;
    else 
        clk4Hzwire <= not clk4Hzwire ;
        counter4Hz <= 0  ;
    end if ;
end if ;
end process ;

process (clk)
begin 
if rising_edge(clk)  then 
    if counter240Hz < 208333 then 
       counter240Hz <= counter240Hz + 1 ;
    else 
        clk240Hzwire <= not clk240Hzwire ;
        counter240Hz <= 0  ;
    end if ;
end if ;
end process ;

clk7out <= clk7Hzwire ;
clk4out <= clk4Hzwire ;
clk10out <= clk10Hzwire ;
clk240out <= clk240Hzwire ;
end Behavioral;