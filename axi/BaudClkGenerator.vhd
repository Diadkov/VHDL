library ieee;
use ieee.std_logic_1164.all;

entity BaudClkGenerator is
    port(
        clk : in std_logic;
        rst : in std_logic;
        baud : out std_logic
    );
end BaudClkGenerator;

architecture rtl of BaudClkGenerator is
    signal r : std_logic := '0';
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst='1' then
                r <= '0';
            else
                r <= not r;
            end if;
        end if;
    end process;

    baud <= r;

end rtl;
