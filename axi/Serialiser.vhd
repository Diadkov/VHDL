library ieee;
use ieee.std_logic_1164.all;

entity Serialiser is
    port(
        clk : in std_logic;
        rst : in std_logic;

        s_axis_tvalid : in std_logic;
        s_axis_tready : out std_logic;
        s_axis_tdata  : in std_logic_vector(7 downto 0);

        m_axis_tvalid : out std_logic;
        m_axis_tready : in std_logic;
        m_axis_tdata  : out std_logic_vector(7 downto 0)
    );
end Serialiser;

architecture rtl of Serialiser is

    signal r : std_logic_vector(7 downto 0);

begin

    s_axis_tready <= m_axis_tready;
    m_axis_tvalid <= s_axis_tvalid;
    m_axis_tdata  <= s_axis_tdata;

end rtl;
