----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/21/2018 04:37:24 AM
-- Design Name: 
-- Module Name: Top_design - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Top_design is
    Port ( Pulse_pin : in STD_LOGIC;
           Clk : in STD_LOGIC;
           Trigger_pin : out STD_LOGIC;
           topselDispA : out STD_LOGIC;
           topselDispB : out STD_LOGIC;
           topselDispC : out STD_LOGIC;
           topselDispD : out STD_LOGIC;
           topsegA : out STD_LOGIC;
           topsegB : out STD_LOGIC;
           topsegC : out STD_LOGIC;
           topsegD : out STD_LOGIC;
           topsegE : out STD_LOGIC;
           topsegF : out STD_LOGIC;
           topsegG : out STD_LOGIC;
           H_sync : out STD_LOGIC; -- VGA Ports
           V_sync : out STD_LOGIC; -- VGA Ports
           VGA_RED: out STD_LOGIC_VECTOR (3 downto 0); -- VGA Ports
           VGA_BLUE : out STD_LOGIC_VECTOR (3 downto 0); -- VGA Ports
           VGA_GREEN : out STD_LOGIC_VECTOR (3 downto 0)); -- VGA Port
end Top_design;

architecture Behavioral of Top_design is

component Range_sensor is
port ( FPGAclk : in STD_LOGIC;
       clk50k : in STD_LOGIC;
       clk1M : in STD_LOGIC;
       TriggerOut : out STD_LOGIC;
       Pulse : in STD_LOGIC;
       distance : out STD_LOGIC_VECTOR(8 downto 0);
       Meters : out STD_LOGIC_VECTOR(3 downto 0);
       Decimeters : out STD_LOGIC_VECTOR(3 downto 0);
       Centimeters : out STD_LOGIC_VECTOR(3 downto 0));
end component;


component segment_driver
    Port (
           displayA : in STD_LOGIC_VECTOR (3 downto 0);
           displayB : in STD_LOGIC_VECTOR (3 downto 0);
           displayC : in STD_LOGIC_VECTOR (3 downto 0);
           displayD : in STD_LOGIC_VECTOR (3 downto 0);
           segA : out STD_LOGIC;
           segB : out STD_LOGIC;
           segC : out STD_LOGIC;
           segD : out STD_LOGIC;
           segE : out STD_LOGIC;
           segF : out STD_LOGIC;
           segG : out STD_LOGIC;
           select_displayA : out STD_LOGIC;
           select_displayB : out STD_LOGIC;
           select_displayC : out STD_LOGIC;
           select_displayD : out STD_LOGIC;
           clk : in STD_LOGIC);
end component;

component VGAsync
    Generic (   Horizontal_FrameSize : natural;
                Vertical_FrameSize : natural
             );
    Port ( Clock : in STD_LOGIC;
           y_control : out STD_LOGIC_VECTOR (11 downto 0);
           x_control : out STD_LOGIC_VECTOR (11 downto 0);
           video_on : out STD_LOGIC;
           H_sync : out STD_LOGIC;
           V_sync : out STD_LOGIC
          );
end component;

COMPONENT VGA
    Generic (   Horizontal_FrameSize : natural;
                Vertical_FrameSize : natural
             );
    Port ( Clock : in STD_LOGIC;
           x_counter : in STD_LOGIC_VECTOR (11 downto 0);
           y_counter : in STD_LOGIC_VECTOR (11 downto 0);
           video : in STD_LOGIC;
           Distance : in STD_LOGIC_VECTOR ( 8 downto 0);
           Seconds, Minutes : in INTEGER range 0 to 60;
           Hours : in INTEGER range 0 to 24;
           VGA_RED : out STD_LOGIC_VECTOR (3 downto 0);
           VGA_GREEN : out STD_LOGIC_VECTOR (3 downto 0);
           VGA_BLUE : out STD_LOGIC_VECTOR (3 downto 0)
          );
end component;

COMPONENT Clock_Display
    Port ( Clock : in STD_LOGIC; -- 100 MHz
           Seconds, Minutes : out INTEGER range 0 to 60;
           Hours : out INTEGER range 0 to 24
           );
END COMPONENT;



signal Ai : STD_LOGIC_VECTOR(3 downto 0);
signal Bi : STD_LOGIC_VECTOR(3 downto 0);
signal Ci : STD_LOGIC_VECTOR(3 downto 0);
signal Di : STD_LOGIC_VECTOR(3 downto 0);

signal sensor_meters : STD_LOGIC_VECTOR(3 downto 0);
signal sensor_decimeters : STD_LOGIC_VECTOR(3 downto 0);
signal sensor_centimeters : STD_LOGIC_VECTOR(3 downto 0);
signal clock50MHZ : STD_LOGIC := '0';
SIGNAL X_count : STD_LOGIC_VECTOR (11 downto 0);
SIGNAL Y_count : STD_LOGIC_VECTOR (11 downto 0);
SIGNAL Vodeo_on : STD_LOGIC;
SIGNAL Seconds, Minutes : INTEGER range 0 to 60;
SIGNAL Hours : INTEGER range 0 to 24;
SIGNAL Clock250MHz, reset : STD_LOGIC;
Signal dist : STD_LOGIC_VECTOR(8 downto 0);
SIGNAL sync_tempK,sync_tempM : STD_LOGIC := '1';
SIGNAL int1,int2 : INTEGER := 0;



begin


clock_div50Mhz_and_50khz: process(Clk)
begin
    if(Clk'event and Clk = '1') then -- 50 MHz Clk
        clock50MHZ <= not clock50MHZ;
    end if;
     if ( rising_edge( Clk)) then
         if ( int1 < 49) then  -- 1Mhz Clock
                   int1 <= int1 + 1;
               else
                   int1 <= 0;
                   sync_tempM <= NOT sync_tempM;
               end if;
           end if;
    
    if ( rising_edge( Clk)) then
          if ( int2 < 49999) then -- 50Khz clock
              int2 <= int2 + 1;
          else
              int2 <= 0;
              sync_tempK <= NOT sync_tempK;
          end if;
      end if;
end process;

seg : segment_driver port map
    (displayA => Ai,
     displayB => Bi,
     displayC => Ci,
     displayD => Di,
     select_displayA => topselDispA,
     select_displayB => topselDispB,
     select_displayC => topselDispC,
     select_displayD => topselDispD,
     segA => topsegA,
     segB => topsegB,
     segC => topsegC,
     segD => topsegD,
     segE => topsegE,
     segF => topsegF,
     segG => topsegG,
     clk => clk);
     
     

R_sense : Range_sensor port map ( FPGAclk => clock50MHZ,
                                  clk50k => sync_tempK,
                                  clk1M => sync_tempM,
                                  TriggerOut => Trigger_pin,
                                  Pulse => Pulse_pin,
                                  distance=>dist,
                                  Meters => sensor_meters,
                                  Decimeters => sensor_decimeters,
                                  Centimeters => sensor_centimeters );
                                  

Ai <= sensor_centimeters;
Bi <= sensor_decimeters;
Ci <= sensor_meters;
Di <= "0000";

    M10 : VGAsync  Generic map ( 1280, 1024)
                    port map( Clock => Clk ,
                              y_control => Y_count ,
                              x_control => x_count ,
                              video_on => vodeo_on ,
                              H_sync => H_sync,
                              V_sync => V_sync 
                             );
                             
  M11 : VGA GENERIC MAP ( 1280, 1024)
                                               port map ( Clock => Clk ,
                                                          x_counter => x_count ,
                                                          y_counter => Y_count ,
                                                          video => vodeo_on,
                                                          Distance => Dist,
                                                          Seconds => Seconds,
                                                          Minutes => Minutes,
                                                          Hours => Hours,
                                                          VGA_RED => VGA_RED ,
                                                          VGA_GREEN => VGA_GREEN ,
                                                          VGA_BLUE => VGA_BLUE
                                                         );
    
                                                          
   M12 : Clock_Display PORT MAP ( Clock => Clk, -- 100 MHz
                                            Seconds => Seconds,
                                            Minutes => Minutes,
                                            Hours => Hours
                                         );                          


end Behavioral;