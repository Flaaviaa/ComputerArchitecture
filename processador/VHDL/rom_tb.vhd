library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_tb is
end;

architecture a_rom_tb of rom_tb is
    component rom
        port( 
            clk      : in  std_logic;
            read_en  : in std_logic;
            endereco : in  unsigned(6 downto 0);
            dado     : out unsigned(15 downto 0) 
        );
    end component;

    -- clock que permite o acesso ao dado
    signal clk : std_logic;
    -- posicao de memoria que queremos o dado
    signal endereco : unsigned(6 downto 0);
    -- saída do registrador da rom é em dado
    signal dado : unsigned(15 downto 0);
    -- serve para ir de registrador em registrador mostrando o que há nele 
    signal contador : unsigned(6 downto 0) := "0000000";
    signal read_en : std_logic;

    begin
    uut : rom port map(	
        clk => clk,
        read_en => read_en,
        endereco => endereco,
        dado => dado
    );

    process 
        begin           
            while contador /= "1111111" loop
            clk <= '0';
            wait for 50 ns;
            clk <= '1';
            wait for 50 ns;
             -- agora fazer o incremento para pegar os dados dos registradores
                contador <= contador + "0000001";
            end loop;
            wait;
        end process;

end architecture;