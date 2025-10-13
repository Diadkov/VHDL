library IEEE;
use IEEE.std_logic_1164.all;

entity tb is end tb;

architecture sim of tb is
    signal D3, D2, D1, D0, MX_OUT : std_logic := '0';
    signal SEL : std_logic_vector(1 downto 0) := "00";
begin
    UUT: entity work.my_4t1_mux
        port map(D3=>D3, D2=>D2, D1=>D1, D0=>D0, SEL=>SEL, MX_OUT=>MX_OUT);

    process
    begin
        D0<='1'; D1<='0'; D2<='0'; D3<='0'; SEL<="00"; wait for 10 ns;
        D0<='0'; D1<='1'; D2<='0'; D3<='0'; SEL<="01"; wait for 10 ns;
        D0<='0'; D1<='0'; D2<='1'; D3<='0'; SEL<="10"; wait for 10 ns;
        D0<='0'; D1<='0'; D2<='0'; D3<='1'; SEL<="11"; wait for 10 ns;
        wait;
    end process;
end sim;
