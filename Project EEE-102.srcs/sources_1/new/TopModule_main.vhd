library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
    use IEEE.NUMERIC_STD.ALL;

entity TopModule_main is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           pulse : in STD_LOGIC;
            H_sync : out STD_LOGIC; -- VGA Ports
            V_sync : out STD_LOGIC; -- VGA Ports
            VGA_RED: out STD_LOGIC_VECTOR (3 downto 0); -- VGA Ports
           VGA_BLUE : out STD_LOGIC_VECTOR (3 downto 0); -- VGA Ports
           VGA_GREEN : out STD_LOGIC_VECTOR (3 downto 0); -- VGA Port
           triggerout : out STD_LOGIC;
           SSEG_AN  : out STD_LOGIC_VECTOR (3 downto 0);
           SSEG_CA  : out STD_LOGIC_VECTOR (6 downto 0);
           step : out STD_LOGIC_VECTOR(3 downto 0);
           belt : out STD_LOGIC_VECTOR(3 downto 0);
           LED : out STD_LOGIC_VECTOR(2 downto 0));
end TopModule_main;

architecture Behavioral of TopModule_main is

component clockModule
Port ( clk : in STD_LOGIC;
       clk7out : out STD_LOGIC;
       clk10out : out STD_LOGIC;
       clk4out : out STD_LOGIC;
       clk240out : out STD_LOGIC);
end component;

component Decimal 
    Port ( distance_in : in STD_LOGIC_VECTOR (8 downto 0);
           Decimal_Out0 : out integer range 0 to 9;
           Decimal_Out1 : out integer range 0 to 9;
           Decimal_Out2 : out  integer range 0 to 9);
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
           Distance : in STD_LOGIC_VECTOR ( 2 downto 0);
           VGA_RED : out STD_LOGIC_VECTOR (3 downto 0);
           VGA_GREEN : out STD_LOGIC_VECTOR (3 downto 0);
           VGA_BLUE : out STD_LOGIC_VECTOR (3 downto 0)
          );
end component;



component SevenDecoder 
    Port ( Seven_in : in integer range 0 to 9 ;
           SevenOut : out STD_LOGIC_VECTOR(6 downto 0));
end component;

component SevenSegmentMux
    Port ( clk : in std_logic ;
           Decimal0 : in integer range 0 to 9 ;
           Decimal1 : in integer range 0 to 9 ;
           Decimal2 : in integer range 0 to 9 ;
           SegmentSelect : out STD_LOGIC_VECTOR (3 downto 0);
           Seven : out integer range 0 to 9 );
end component;

component Distance_Calculation is
    Port ( clk : in STD_LOGIC;
           calculation_reset : in STD_LOGIC;
           pulse : in STD_LOGIC;
           distance : out STD_LOGIC_VECTOR (8 downto 0));
end component;

component Trigger_generator is
    Port ( clk : in STD_LOGIC;
           Trigger : out STD_LOGIC);
end component;

component clockDivider is
    Port ( clk_in : in STD_LOGIC;
           clk_out : out STD_LOGIC;
           clk_1 : out STD_LOGIC;
           clk_box : out STD_LOGIC);
end component;

component StepModule is
    Port ( clk : in STD_LOGIC;
           dir : in STD_LOGIC_VECTOR( 1 downto 0);
           step : out STD_LOGIC_VECTOR( 3 downto 0));
end component;

component StepperControl is
    Port ( clk : in STD_LOGIC;
           decimal0 : in integer;
           decimal1 : in integer;
           decimal2 : in integer;
           reset : in STD_LOGIC;
           direction : out STD_LOGIC_VECTOR( 1 downto 0);
           boxes : out STD_LOGIC_VECTOR(2 downto 0);
           stop_sig : out STD_LOGIC);
end component;

component conveyor is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           belt : out STD_LOGIC_VECTOR (3 downto 0));
end component;

signal triggout : STD_LOGIC;
signal distance_out : STD_LOGIC_VECTOR (8 downto 0);
signal clk7  : STD_LOGIC;
signal clk10  : STD_LOGIC;
signal clk4  : STD_LOGIC;
signal clk240  : STD_LOGIC;
signal clk_sig  : STD_LOGIC;
signal Decimal0 : integer range 0 to 9;
signal Decimal1 : integer range 0 to 9;
signal Decimal2 : integer range 0 to 9;
signal seven_wire : integer range 0 to 9;

SIGNAL X_count : STD_LOGIC_VECTOR (11 downto 0);
SIGNAL Y_count : STD_LOGIC_VECTOR (11 downto 0);
SIGNAL Vodeo_on : STD_LOGIC;
SIGNAL sync_tempK,sync_tempM : STD_LOGIC := '1';
SIGNAL int1,int2 : INTEGER := 0;


signal clk_wire : STD_LOGIC;
signal clk_wire1 : STD_LOGIC;
signal direction : STD_LOGIC_VECTOR( 1 downto 0);
signal dir : STD_LOGIC;  
signal change_dir : STD_LOGIC;
signal clk_box : STD_LOGIC;
signal boxess: STD_LOGIC_VECTOR( 2 downto 0 );
signal stop_sigWire : STD_LOGIC;

begin

trigger_gen : trigger_generator PORT MAP(
clk => clk_sig,
Trigger => triggout);

pulsewidth : distance_calculation PORT MAP(
clk => clk_sig,
calculation_reset => triggout,
pulse => pulse,
distance => distance_out);

Clocks : clockModule PORT MAP( 
clk => clk_sig,
clk240out => clk240,
clk7out => clk7,
clk10out => clk10,
clk4out => clk4);

Decimals : Decimal PORT MAP(
distance_in  => distance_out,
Decimal_Out0 => Decimal0,
Decimal_Out1 => Decimal1,
Decimal_Out2 => Decimal2);
           
Decoder : SevenDecoder PORT MAP(
Seven_in => seven_wire,
SevenOut => SSEG_CA); 
 
Muxing : SevenSegmentMux PORT MAP(
clk  => clk240,
Decimal0 => Decimal0,
Decimal1 => Decimal1,
Decimal2 => Decimal2,
SegmentSelect => SSEG_AN,
Seven => seven_wire);

u0 : clockDivider PORT MAP(
clk_in => clk,
clk_out => clk_wire,
clk_1 => clk_wire1,
clk_box => clk_box);
                        
u1 : StepModule PORT MAP(
clk => clk_wire,
dir => direction,
step => step);
            
u2 : StepperControl PORT MAP(
clk => clk_wire1,
Decimal0 => Decimal0,
Decimal1 => Decimal1,
Decimal2 => Decimal2,
reset => reset,
direction => direction,
boxes => boxess,
stop_sig => stop_sigWire);

Conveyor_Belt : conveyor PORT MAP(
clk => clk_wire,
reset => stop_sigWire,
belt => belt);
            
triggerout <= triggout;
clk_sig <= clk ;

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
                                                          Distance => boxess,
                                                          VGA_RED => VGA_RED ,
                                                          VGA_GREEN => VGA_GREEN ,
                                                          VGA_BLUE => VGA_BLUE
                                                         );
  LED <= boxess;             

end Behavioral;
