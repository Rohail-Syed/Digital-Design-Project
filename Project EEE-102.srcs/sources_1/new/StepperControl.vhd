library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity StepperControl is
    Port ( clk : in STD_LOGIC;
           decimal0 : in integer;
           decimal1 : in integer;
           decimal2 : in integer;
           reset : in STD_LOGIC;
           direction : out STD_LOGIC_VECTOR(1 downto 0);
           boxes : out STD_LOGIC_VECTOR(2 downto 0);
           stop_sig : out STD_LOGIC);
end StepperControl;

architecture Behavioral of StepperControl is
signal change_dir : STD_LOGIC;
signal dir : STD_LOGIC;
signal seconds : integer := 0;
signal count : STD_LOGIC_VECTOR(2 downto 0);
signal counter : STD_LOGIC_VECTOR(2 downto 0) := count - 1;

begin

process( decimal0, decimal1, decimal2, dir, reset)
begin
if count = "110" then
    dir <= '1';
    stop_sig <= '1';
    else
        if ( Decimal2 = 0 and Decimal1 = 0 and Decimal0 = 9) or( Decimal2 = 0 and Decimal1 = 0 and Decimal0 = 8) or( Decimal2 = 0 and Decimal1 = 0 and Decimal0 = 7) or ( Decimal2 = 0 and Decimal1 = 0 and Decimal0 = 6) or( Decimal2 = 0 and Decimal1 = 0 and Decimal0 = 5) or( Decimal2 = 0 and Decimal1 = 0 and Decimal0 = 4) or ( Decimal2 = 0 and Decimal1 = 0 and Decimal0 = 3) then
                dir <= '1';
--        else dir <= '0';
            if ( Decimal2 = 0 and Decimal1 = 1 and Decimal0 = 8) or ( Decimal2 = 0 and Decimal1 = 1 and Decimal0 = 7) or ( Decimal2 = 0 and Decimal1 = 1 and Decimal0 = 6) or ( Decimal2 = 0 and Decimal1 = 1 and Decimal0 = 5) or ( Decimal2 = 0 and Decimal1 = 1 and Decimal0 = 4) or ( Decimal2 = 0 and Decimal1 = 1 and Decimal0 = 3) or ( Decimal2 = 0 and Decimal1 = 1 and Decimal0 = 2) or ( Decimal2 = 0 and Decimal1 = 1 and Decimal0 = 1) or ( Decimal2 = 0 and Decimal1 = 1 and Decimal0 = 0) then
                dir <= '0';
--            else dir <= '1';
            end if;
        end if;
        stop_sig <= '0';
end if;
end process;

process( clk, change_dir, dir, seconds)
begin
    if dir = '1' then
        if rising_edge( clk) then
            seconds <= seconds + 1;
            if seconds = 3 then
                change_dir <= '1';
                count <= count + 1;
            end if;
        end if;
    end if;
    if dir = '0' then
        seconds <= 0;
        change_dir <= '0';
        count <= count;
    end if;
end process;

direction <= change_dir & dir;
boxes <= counter;
end Behavioral;
