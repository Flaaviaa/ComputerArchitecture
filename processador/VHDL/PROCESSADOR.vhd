library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity PROCESSADOR is
    port(
        clk : in std_logic;
        rst : in std_logic;
        estado : in unsigned(1 downto 0);

        -- constante_entrada_pc : out unsigned(6 downto 0);
        -- endereco_saida_pc : out unsigned(6 downto 0);
        

        -- ula_ina : out unsigned(15 downto 0);
        -- ula_inb : out unsigned(15 downto 0);

        -- somar : out std_logic;
        -- saltar : out std_logic;

        
        -- result : out unsigned(15 downto 0);

        -- jbit5 : out std_logic;
        -- jump : out std_logic;
        -- branch : out std_logic;

        instrucao_erro : out unsigned(3 downto 0);
        brake : out std_logic;
        fet_erro_endereco : out std_logic
    );
end entity;


architecture A_PROCESSADOR of PROCESSADOR is
    signal instrucao : unsigned(15 downto 0) := "0000000000000000";
    signal signal_brake : std_logic := '0';
    signal clk_controled : std_logic := '0';
    signal fet_wr_en_pc : std_logic := '0';
    signal fet_instrucao_branch : std_logic := '0';
    signal fet_instrucao_jump : std_logic := '0';
    signal fet_saida_mux_pc : std_logic := '0';
    signal fet_endereco_entrada_pc : unsigned(6 downto 0) := "0000000";
    signal fet_instrucao : unsigned(15 downto 0) := "0000000000000000";

    signal exe_select_mux_pc : unsigned(1 downto 0) := "00";
    signal exe_select_op_ula : unsigned(1 downto 0) := "00";
    signal exe_ina_ula : unsigned(15 downto 0) := "0000000000000000";
    signal exe_inb_ula : unsigned(15 downto 0) := "0000000000000000";
    signal exe_bit5 : std_logic := '0';
    signal exe_regflags_wr_en : std_logic := '0';
    signal exe_regula_wr_en : std_logic := '0';
    signal exe_result_ula : unsigned(15 downto 0) := "0000000000000000";
    signal exe_saida_mux_pc : std_logic := '0';
    signal exe_saida_mux_pc_ou_bit5 : std_logic := '0';

    signal ina_ula : unsigned(15 downto 0) := "0000000000000000";
    signal inb_ula : unsigned(15 downto 0) := "0000000000000000";
    signal saida_ula : unsigned(15 downto 0) := "0000000000000000";
    signal bit5 : std_logic := '0';
    signal wr_en_pc : std_logic := '0';
    signal endereco_pc : unsigned(6 downto 0) := "0000000";
    signal instrucao_branch : std_logic := '0';
    signal instrucao_jump : std_logic := '0';
    signal instrucao_jumpbit5 : std_logic := '0';
    signal select_op_ula : unsigned(1 downto 0) := "00";
    signal select_mux_pc : unsigned(1 downto 0) := "00";
    signal exe_saida_reg : unsigned(15 downto 0) := "0000000000000000";
    signal regflags_wr_en : std_logic := '0';
    signal regula_wr_en : std_logic := '0';

    component FATCH_PACKAGE is
        port(
            clk : in std_logic;
            rst : in std_logic;
            estado : in unsigned(1 downto 0);
            fet_wr_en_pc : in std_logic;
            fet_instrucao_branch : in std_logic;
            fet_instrucao_jump : in std_logic;
            fet_saida_mux_pc : in std_logic;
            fet_endereco_entrada_pc : in unsigned(6 downto 0);
            fet_instrucao : out unsigned(15 downto 0);
            fet_erro_endereco : out std_logic
        );
    end component;
    component EXECUTE_PACKAGE is 
        port(
            clk : in std_logic;
            rst : in std_logic;
            estado : in unsigned(1 downto 0);
            exe_select_mux_pc : in unsigned(1 downto 0);
            exe_select_op_ula : in unsigned(1 downto 0);
            exe_ina_ula : in unsigned(15 downto 0);
            exe_inb_ula : in unsigned(15 downto 0);
            exe_bit5 : in std_logic;
            exe_regflags_wr_en : in std_logic;
            exe_regula_wr_en : in std_logic;
            exe_result_ula : out unsigned(15 downto 0);
            exe_saida_mux_pc : out std_logic;
            exe_saida_reg : out unsigned(15 downto 0)
        
        );
    end component;
    component DECODER_PACKAGE is 
        port(
            clk : in std_logic;
            rst : in std_logic;
            estado : in unsigned(1 downto 0);
            instrucao : in unsigned(15 downto 0);
            saida_ula : in unsigned(15 downto 0);
            bit5 : out std_logic;
            wr_en_pc : out std_logic;
            endereco_pc : out unsigned(6 downto 0);
            instrucao_branch : out std_logic;
            instrucao_jump : out std_logic;
            ina_ula : out unsigned(15 downto 0);
            inb_ula : out unsigned(15 downto 0);
            select_op_ula : out unsigned(1 downto 0);
            select_mux_pc : out unsigned(1 downto 0);
            instrucao_erro : out unsigned(3 downto 0);
            brake : out std_logic;
            regflags_wr_en : out std_logic;
            regula_wr_en : out std_logic
        );
    end component;
    
    begin
        FATCH : FATCH_PACKAGE port map(
            clk => clk_controled,
            rst => rst,
            estado => estado,
            fet_wr_en_pc => fet_wr_en_pc,
            fet_instrucao_branch => fet_instrucao_branch,
            fet_instrucao_jump => fet_instrucao_jump,
            fet_saida_mux_pc => fet_saida_mux_pc,
            fet_endereco_entrada_pc => fet_endereco_entrada_pc,
            fet_instrucao => fet_instrucao,
            fet_erro_endereco => fet_erro_endereco
        );
        DECODER : DECODER_PACKAGE port map(
            clk => clk_controled,
            rst => rst,
            estado => estado,
            instrucao => instrucao,
            saida_ula => saida_ula,
            bit5 => bit5,
            wr_en_pc => wr_en_pc,
            endereco_pc => endereco_pc,
            instrucao_branch => instrucao_branch,
            instrucao_jump => instrucao_jump,
            ina_ula => ina_ula,
            inb_ula => inb_ula,
            select_op_ula => select_op_ula,
            select_mux_pc => select_mux_pc,
            instrucao_erro => instrucao_erro,
            brake => signal_brake,
            regflags_wr_en => regflags_wr_en,
            regula_wr_en => regula_wr_en
        );
        EXECUTE : EXECUTE_PACKAGE port map(
            clk => clk_controled,
            rst => rst,
            estado => estado,
            exe_select_mux_pc => exe_select_mux_pc,
            exe_select_op_ula => exe_select_op_ula,
            exe_ina_ula => exe_ina_ula,
            exe_inb_ula => exe_inb_ula,
            exe_bit5 => exe_bit5,
            exe_regflags_wr_en => exe_regflags_wr_en,
            exe_regula_wr_en => exe_regula_wr_en,
            exe_result_ula => exe_result_ula,
            exe_saida_reg => exe_saida_reg,
            exe_saida_mux_pc => exe_saida_mux_pc
        );
        -- conectar cabos =(
            brake <= signal_brake;
            clk_controled <= clk when signal_brake = '0' else '0';
            exe_regflags_wr_en <= regflags_wr_en;
            exe_regula_wr_en <= regula_wr_en;
            saida_ula <= exe_result_ula;
            instrucao <= fet_instrucao;

            fet_wr_en_pc <= wr_en_pc;
            fet_endereco_entrada_pc <= endereco_pc;
            fet_instrucao_branch <= instrucao_branch;
            fet_instrucao_jump <= instrucao_jump;
            fet_saida_mux_pc <= exe_saida_mux_pc;

            exe_select_mux_pc <= select_mux_pc;
            exe_select_op_ula <= select_op_ula;
            exe_ina_ula <= ina_ula;
            exe_inb_ula <= inb_ula;
            exe_bit5 <= bit5;

            -- ula_ina <= ina_ula;
            -- ula_inb <= inb_ula;
            -- result <= saida_ula;
            -- constante_entrada_pc <= endereco_pc;

end architecture;