library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity digital_lock_tb is
end digital_lock_tb;

architecture behavior of digital_lock_tb is

component digital_lock
    Port (
        clk           : in STD_LOGIC;
        reset         : in STD_LOGIC;
        enter         : in STD_LOGIC;
        digit_input   : in STD_LOGIC_VECTOR(3 downto 0);

        unlock_led    : out STD_LOGIC;
        alert_led     : out STD_LOGIC;
        seg_display   : out STD_LOGIC_VECTOR(6 downto 0)
    );
end component;

signal clk         : STD_LOGIC := '0';
signal reset       : STD_LOGIC := '0';
signal enter       : STD_LOGIC := '0';
signal digit_input : STD_LOGIC_VECTOR(3 downto 0);

signal unlock_led  : STD_LOGIC;
signal alert_led   : STD_LOGIC;
signal seg_display : STD_LOGIC_VECTOR(6 downto 0);

begin

uut: digital_lock
port map (
    clk => clk,
    reset => reset,
    enter => enter,
    digit_input => digit_input,
    unlock_led => unlock_led,
    alert_led => alert_led,
    seg_display => seg_display
);

clk_process : process
begin
    clk <= '0';
    wait for 5 ns;
    clk <= '1';
    wait for 5 ns;
end process;

stim_proc: process
begin

    reset <= '1';
    wait for 20 ns;
    reset <= '0';

    digit_input <= "0001";
    enter <= '1';
    wait for 10 ns;
    enter <= '0';

    wait for 10 ns;

    digit_input <= "0010";
    enter <= '1';
    wait for 10 ns;
    enter <= '0';

    wait for 10 ns;

    digit_input <= "0011";
    enter <= '1';
    wait for 10 ns;
    enter <= '0';

    wait for 10 ns;

    digit_input <= "0100";
    enter <= '1';
    wait for 10 ns;
    enter <= '0';

    wait;

end process;

end behavior;