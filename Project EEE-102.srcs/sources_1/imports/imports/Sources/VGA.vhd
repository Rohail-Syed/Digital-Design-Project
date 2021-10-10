library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;

entity VGA is
    Generic (   Horizontal_FrameSize : natural;
                Vertical_FrameSize : natural
             );
    Port (  Clock : in STD_LOGIC;
            X_counter, Y_counter : in STD_LOGIC_VECTOR ( 11 downto 0);
            Video : in STD_LOGIC;
            Distance: in STD_LOGIC_VECTOR ( 2 downto 0);
            VGA_RED, VGA_GREEN, VGA_BLUE : out STD_LOGIC_VECTOR ( 3 downto 0)
          );
end VGA;

architecture Behavioral of VGA is
COMPONENT Pixel_Status is
    Port (  Clock : in STD_LOGIC;
            X, Y : in STD_LOGIC_VECTOR ( 11 downto 0);
            Distance: in STD_LOGIC_VECTOR ( 2 downto 0);
            pixel : out STD_LOGIC
          );
END COMPONENT;
    
    SIGNAL X, Y : std_logic_vector ( 11 downto 0);
    SIGNAL Pixel, Box, Go : std_logic := '0';
    
    SIGNAL VGA_red_o : std_logic_vector ( 3 downto 0);
    SIGNAL VGA_green_o : std_logic_vector ( 3 downto 0);
    SIGNAL VGA_blue_o : std_logic_vector ( 3 downto 0);
    -- VGA R, G and B signals to connect output with the design
    SIGNAL VGA_red_comb : std_logic_vector ( 3 downto 0);
    SIGNAL VGA_green_comb : std_logic_vector ( 3 downto 0);
    SIGNAL VGA_blue_comb : std_logic_vector ( 3 downto 0);

    
begin
    PS : Pixel_Status PORT MAP (   Clock => Clock,
                                    X => x_counter,
                                   Y =>  Y_counter,
                                   Distance => Distance,
                                 pixel =>   pixel
                                );
    
   
    
    Go <= pixel OR box;
    VGA_red_o <= "1111";--red;
    VGA_green_o <= "0000";--green;
    VGA_blue_o <= "1111";--blue;
    X <= X_counter;
    Y <= Y_counter;
    VGA_red_comb <= (Go & Go & Go & Go) and VGA_red_o;
    VGA_green_comb <= (Go & Go & Go & Go) and VGA_green_o;
    VGA_blue_comb <= (Go & Go & Go & Go) and VGA_blue_o;

    process ( Clock)
    begin
        if ( rising_edge( Clock) and Video = '1') then
            VGA_RED <= vga_red_comb;
            VGA_GREEN <= vga_green_comb;
            VGA_BLUE <= vga_blue_comb;
        end if;
    end process;
end Behavioral;