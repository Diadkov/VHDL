library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TopLevelModule is
    port(
        clk : in std_logic;
        rst : in std_logic;
        rx  : in std_logic;
        tx  : out std_logic
    );
end TopLevelModule;

architecture rtl of TopLevelModule is

    signal s_tvalid, s_tready : std_logic;
    signal s_tdata            : std_logic_vector(7 downto 0);

    signal b_tvalid, b_tready : std_logic;
    signal b_tdata            : std_logic_vector(7 downto 0);

    signal u_tvalid, u_tready : std_logic;
    signal u_tdata            : std_logic_vector(7 downto 0);

begin

    UART_RX_inst : entity work.UART_rx
        port map(
            clk => clk,
            rst => rst,
            rx  => rx,
            m_axis_tvalid => s_tvalid,
            m_axis_tready => s_tready,
            m_axis_tdata  => s_tdata
        );

    BUF_inst : entity work.CommandBuffer
        port map(
            clk => clk,
            rst => rst,
            s_axis_tvalid => s_tvalid,
            s_axis_tready => s_tready,
            s_axis_tdata  => s_tdata,
            m_axis_tvalid => b_tvalid,
            m_axis_tready => b_tready,
            m_axis_tdata  => b_tdata
        );

    UART_TX_inst : entity work.UART_tx
        port map(
            clk => clk,
            rst => rst,
            s_axis_tvalid => b_tvalid,
            s_axis_tready => b_tready,
            s_axis_tdata  => b_tdata,
            tx => tx
        );

end rtl;
