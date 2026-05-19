library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity digital_lock is
    Port (
        clk           : in STD_LOGIC;
        reset         : in STD_LOGIC;
        enter         : in STD_LOGIC;
        digit_input   : in STD_LOGIC_VECTOR(3 downto 0);

        unlock_led    : out STD_LOGIC;
        alert_led     : out STD_LOGIC;
        seg_display   : out STD_LOGIC_VECTOR(6 downto 0)
    );
end digital_lock;

architecture Behavioral of digital_lock is

    type state_type is (IDLE, DIGIT1, DIGIT2, DIGIT3, CHECK);
    signal state : state_type := IDLE;

    signal pass1, pass2, pass3, pass4 : STD_LOGIC_VECTOR(3 downto 0);

    constant correct1 : STD_LOGIC_VECTOR(3 downto 0) := "0001";
    constant correct2 : STD_LOGIC_VECTOR(3 downto 0) := "0010";
    constant correct3 : STD_LOGIC_VECTOR(3 downto 0) := "0011";
    constant correct4 : STD_LOGIC_VECTOR(3 downto 0) := "0100";

    signal wrong_attempts : integer := 0;

begin

process(clk, reset)
begin

    if reset = '1' then
        state <= IDLE;
        unlock_led <= '0';
        alert_led <= '0';
        wrong_attempts <= 0;

    elsif rising_edge(clk) then

        case state is

            when IDLE =>
                unlock_led <= '0';

                if enter = '1' then
                    pass1 <= digit_input;
                    state <= DIGIT1;
                end if;

            when DIGIT1 =>

                if enter = '1' then
                    pass2 <= digit_input;
                    state <= DIGIT2;
                end if;

            when DIGIT2 =>

                if enter = '1' then
                    pass3 <= digit_input;
                    state <= DIGIT3;
                end if;

            when DIGIT3 =>

                if enter = '1' then
                    pass4 <= digit_input;
                    state <= CHECK;
                end if;

            when CHECK =>

                if (pass1 = correct1 and
                    pass2 = correct2 and
                    pass3 = correct3 and
                    pass4 = correct4) then

                    unlock_led <= '1';
                    alert_led <= '0';
                    wrong_attempts <= 0;

                else

                    unlock_led <= '0';
                    wrong_attempts <= wrong_attempts + 1;

                    if wrong_attempts >= 2 then
                        alert_led <= '1';
                    end if;

                end if;

                state <= IDLE;

            when others =>
                state <= IDLE;

        end case;

    end if;

end process;

seg_display <= "1000000" when unlock_led = '1'
               else "1111001";

end Behavioral;