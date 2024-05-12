library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UC is
    port(
        clk,rst,wr_en : in std_logic;
        opcode_erro : out std_logic;
        instrucao : out unsigned(15 downto 0)
    );
end entity;

architecture a_UC of UC is
    signal conexao_pc_rom : unsigned(6 downto 0) := "0000000";
    signal estado : unsigned(0 downto 0) := "0";
    signal incrementar_pc : std_logic := '0';
    signal saltar : std_logic := '0';
    signal salto_endereco : unsigned(6 downto 0) := "0000000";
    signal endereco_entrada_pc : unsigned(6 downto 0) := "0000000";
    signal read_en : std_logic := '0';
    signal opcode : unsigned(3 downto 0) := "0000";
    signal instrucao_saida : unsigned(15 downto 0) := "0000000000000000";

    component PC is
        port(
            rst : in std_logic;
            clk : in std_logic;
            wr_en : in std_logic;
            saltar : in std_logic;
            endereco_entrada : in unsigned(6 downto 0);
            endereco_saida : out unsigned(6 downto 0)
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

    component maquina_de_estados is
        port( 
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            saida    : out unsigned(0 downto 0)
        );
    end component;

    begin
    PC_instance : PC port map(
        rst => rst,
        clk => clk,
        wr_en => incrementar_pc,
        saltar => saltar,
        endereco_entrada => endereco_entrada_pc,
        endereco_saida => conexao_pc_rom
        );

    rom_instance : rom port map(
        clk => clk,
        read_en => read_en,
        endereco => conexao_pc_rom,
        dado => instrucao_saida
        );

    maquina_de_estados_instance : maquina_de_estados port map(
        clk => clk,
        rst => rst,
        wr_en => '1',
        saida => estado
    );

    -- ler a rom no estado 0
    read_en <= '1' when estado = "0" else '0';
    -- incrementar pc no estado 1
    incrementar_pc <= '1' when estado = "1" else '0';
    -- condicao para o salto
    opcode <= instrucao_saida(3 downto 0);
    saltar <= '1' when opcode = "0011" else '0';
    opcode_erro <= '1' when opcode > "0111" else '0';
    -- setando para qual registrador é o salto
    --endereco_entrada_pc <= instrucao_saida(6 downto 0) when saltar = '1' else conexao_pc_rom;
    endereco_entrada_pc <= instrucao_saida(15 downto 9) when saltar = '1' else conexao_pc_rom ;
    
    instrucao <= instrucao_saida;


end architecture;