library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FATCH_PACKAGE is
    port(
        -- controle
        clk : in std_logic;
        rst : in std_logic;
        estado : in unsigned(1 downto 0);
        -- entrada
        fet_wr_en_pc : in std_logic;
        fet_somar_pc : in std_logic;
        fet_saltar_pc : in std_logic;
        fet_endereco_entrada_pc : in unsigned(6 downto 0);
        fet_overflow_flag_ula : in std_logic;
        fet_instrucao_branch : in std_logic;
        -- saída
        fet_instrucao : out unsigned(15 downto 0)
    );
end entity;


architecture A_FATCH_PACKAGE of FATCH_PACKAGE is

    signal PC_wr_en : std_logic := '0';
    signal PC_saltar : std_logic := '0';
    signal PC_somar : std_logic := '0';
    signal PC_endereco_entrada : unsigned(6 downto 0) := "0000000";
    signal PC_endereco_saida : unsigned(6 downto 0) := "0000000";
    signal PC_erro_endereco : std_logic := '0';

    signal ROM_read_en  : std_logic;
    signal ROM_endereco : unsigned(6 downto 0);
    signal ROM_dado : unsigned(15 downto 0);

    signal REG_wr_en    : std_logic;
    signal REG_data_in  : unsigned(15 downto 0);
    signal REG_data_out : unsigned(15 downto 0);

    component PC is
        port(
            rst : in std_logic;
            clk : in std_logic;
            wr_en : in std_logic;
            saltar : in std_logic;
            somar : in std_logic;
            endereco_entrada : in unsigned(6 downto 0);
            endereco_saida : out unsigned(6 downto 0);
            erro_endereco : out std_logic := '0'
        );
    end component;

    component rom is
        port(
            clk : in std_logic;
            read_en  : in std_logic;
            endereco : in unsigned(6 downto 0);
            dado : out unsigned(15 downto 0)
        );
    end component;

    component reg16bits is
        port( 
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;
    begin

    
    
    
    PC_instance : PC port map(
        rst => rst,
        clk => clk,
        wr_en => PC_wr_en,
        saltar => PC_saltar,
        somar => PC_somar,
        endereco_entrada => PC_endereco_entrada,
        endereco_saida => PC_endereco_saida,
        erro_endereco => PC_erro_endereco
        );

    rom_instance : rom port map(
        clk => clk,
        read_en => ROM_read_en,
        endereco => ROM_endereco,
        dado => ROM_dado
        );

    reg16bits_instance : reg16bits port map(
        clk => clk,
        rst => rst,
        wr_en => REG_wr_en,
        data_in => REG_data_in,
        data_out => fet_instrucao
        );  

        -- conexoes
        PC_endereco_entrada <= fet_endereco_entrada_pc;
        ROM_endereco <= PC_endereco_saida;
        REG_data_in <= ROM_dado;
        PC_wr_en <= fet_wr_en_pc;
        PC_somar <= fet_somar_pc;
        -- condicoes
        PC_saltar <= '1' when fet_overflow_flag_ula = '1' and fet_instrucao_branch = '1' else '0';
        -- estados
        PC_wr_en <= '1' when estado = "10" else '0';
        ROM_read_en <= '1' when estado = "00" else '0';
        REG_wr_en <= '1' when estado = "01" else '0';

end architecture;