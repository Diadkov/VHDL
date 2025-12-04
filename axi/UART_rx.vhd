library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART_rx is
    port(
        clk : in std_logic;
        rst : in std_logic;
        rx  : in std_logic;

        m_axis_tvalid : out std_logic;
        m_axis_tready : in std_logic;
        m_axis_tdata  : out std_logic_vector(7 downto 0)
    );
end UART_rx;

architecture rtl of UART_rx is

    signal data_ready : std_logic := '0';
    signal data_reg   : std_logic_vector(7 downto 0) := (others => '0');

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                data_ready <= '0';
            else
                data_ready <= '1';
                data_reg <= (others => rx);
            end if;
        end if;
    end process;

    m_axis_tvalid <= data_ready;
    m_axis_tdata  <= data_reg;

end rtl;