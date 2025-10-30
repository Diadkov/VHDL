entity pipeline_add is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        in0    : in  std_logic_vector(7 downto 0);
        in1    : in  std_logic_vector(7 downto 0);
        in2    : in  std_logic_vector(7 downto 0);
        in3    : in  std_logic_vector(7 downto 0);
        in4    : in  std_logic_vector(7 downto 0);
        in5    : in  std_logic_vector(7 downto 0);
        in6    : in  std_logic_vector(7 downto 0);
        in7    : in  std_logic_vector(7 downto 0);
        in8    : in  std_logic_vector(7 downto 0);
        in9    : in  std_logic_vector(7 downto 0);
        sum_out: out std_logic_vector(11 downto 0)
    );
end pipeline_add;
