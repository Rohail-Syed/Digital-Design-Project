library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SevenSegmentMux is
    Port ( clk : in std_logic ;
           Decimal0 : in integer range 0 to 9 ;
           Decimal1 : in integer range 0 to 9 ;
           Decimal2 : in integer range 0 to 9 ;
           SegmentSelect : out STD_LOGIC_VECTOR (3 downto 0);
           Seven : out integer range 0 to 9 );
end SevenSegmentMux;

architecture Behavioral of SevenSegmentMux is
signal counter : std_logic_vector(1 downto 0) ;

begin

process (clk)
begin
if rising_edge(clk)  then 
            if counter = "00" then 
               SegmentSelect <= "1110" ;
               Seven <= Decimal0;
               counter <= "01" ;
            end if; 
            if counter = "01" then 
               SegmentSelect <= "1101" ;
               Seven <= Decimal1;
               counter <= "10" ;
            end if; 
            if counter = "10" then 
               SegmentSelect <= "1011" ;
               Seven <= Decimal2;
               counter <= "11" ;
               end if; 
            if counter = "11" then 
               SegmentSelect <= "0111" ;
               Seven <= 0 ;
               counter <= "00" ;
               end if;
end if ;
end process;

end Behavioral;
