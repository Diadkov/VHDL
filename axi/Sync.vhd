library ieee;
use ieee.std_logic_1164.all;

entity Sync is
    port(
        clk : in std_logic;
        rst : in std_logic;
        din : in std_logic;
        dout : out std_logic
    );
end Sync;

architecture rtl of Sync is
    signal r : std_logic;
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst='1' then
                r <= '0';
            else
                r <= din;
            end if;
        end if;
    end process;

    dout <= r;

end rtl;
