library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
    port (
        clk      : in std_logic := '0';
        endereco : in unsigned(15 downto 0) := "0000000000000000";
        wr_en    : in std_logic := '0';
        dado_in  : in unsigned(15 downto 0) := "0000000000000000";
        dado_out : out unsigned(15 downto 0) := "0000000000000000";
        acess_error : out std_logic := '0'

    );

end entity;

architecture a_ram of ram is
    type mem is array (0 to 127) of unsigned(15 downto 0);
    signal conteudo_ram : mem := (
        others => (others => '0')
    );
begin
    process (clk, wr_en)
    begin
        if wr_en = '1' then
            if rising_edge(clk) then
                if endereco(15 downto 7) = "000000000" then 
                    conteudo_ram(to_integer(endereco(6 downto 0))) <= dado_in;
                    acess_error <= '0';
                else 
                    acess_error <= '1';
                end if;
            end if;
        end if;
    end process;
    dado_out <= conteudo_ram(to_integer(endereco));
end architecture;