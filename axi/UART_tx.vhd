library ieee;
use ieee.std_logic_1164.all;

entity UART_tx is
    port(
        clk : in std_logic;
        rst : in std_logic;

        s_axis_tvalid : in std_logic;
        s_axis_tready : out std_logic;
        s_axis_tdata  : in std_logic_vector(7 downto 0);

        tx : out std_logic
    );
end UART_tx;

architecture rtl of UART_tx is

    signal busy : std_logic := '0';
    signal dreg : std_logic_vector(7 downto 0);

begin

    s_axis_tready <= not busy;

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                busy <= '0';
            else
                if s_axis_tvalid = '1' and s_axis_tready = '1' then
                    busy <= '1';
                    dreg <= s_axis_tdata;
                else
                    busy <= '0';
                end if;
            end if;
        end if;
    end process;

    tx <= dreg(0);

end rtl;
