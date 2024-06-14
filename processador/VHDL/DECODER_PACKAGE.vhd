library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity DECODER_PACKAGE is
    port(
        clk : in std_logic;
        rst : in std_logic;

        instrucao : in unsigned(15 downto 0);
        estado : in unsigned(1 downto 0);
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
end entity;


architecture A_DECODER_PACKAGE of DECODER_PACKAGE is
    signal UC_regflags_wr_en : std_logic := '0'; 
    signal UC_regula_wr_en : std_logic := '0'; 
    
    signal UC_instrucao : unsigned(15 downto 0) := "0000000000000000";
    signal UC_select_mux_regs : std_logic := '1';
    signal UC_select_ula_op : unsigned(1 downto 0) := "00";
    signal UC_select_mux_ula : std_logic := '0';
    signal UC_instrucao_branch : std_logic := '0';
    signal UC_instrucao_jump : std_logic := '0';
    signal UC_acc_wr_en : std_logic := '0';
    signal UC_select_mux_acc : unsigned(1 downto 0) := "00";
    signal UC_reg_wr_en : std_logic := '1'; 
    signal UC_selec_reg1 : unsigned(2 downto 0) := "000";
    signal UC_selec_reg2 : unsigned(2 downto 0) := "000";
    signal UC_registrador_para_salvar : unsigned(2 downto 0) := "000";

    signal acc_data_in  : unsigned(15 downto 0) := "0000000000000000";
    signal acc_data_out : unsigned(15 downto 0) := "0000000000000000";
    signal acc_wr_en : std_logic :=  '1';

    signal constante_instrucao : unsigned(15 downto 0) := "0000000000000000";
    signal constante_delta_salto_branch : unsigned(6 downto 0) := "0000000";
    signal constante_saida : unsigned(15 downto 0) := "0000000000000000";


    signal reg_select_1      : unsigned(2 downto 0) := "000";
    signal reg_select_2      : unsigned(2 downto 0) := "000";     
    signal reg_regWrite          : unsigned(2 downto 0) := "000";
    signal reg_entr              : unsigned(15 downto 0):= "0000000000000000";
    signal reg_wr_en         : std_logic := '1';
    signal reg_data1         : unsigned(15 downto 0) := "0000000000000000";  
    signal reg_data2         : unsigned(15 downto 0) := "0000000000000000";

    signal mux_ula_controle : std_logic := '0';
    signal mux_ula_entradazero : unsigned(15 downto 0) := "0000000000000000";
    signal mux_ula_entradaum : unsigned(15 downto 0) := "0000000000000000";
    signal mux_ula_saida : unsigned(15 downto 0) := "0000000000000000";

    signal mux_reg_controle : std_logic := '0';
    signal mux_reg_entradazero : unsigned(15 downto 0) := "0000000000000000";
    signal mux_reg_entradaum : unsigned(15 downto 0) := "0000000000000000";
    signal mux_reg_saida : unsigned(15 downto 0):= "0000000000000000";

    signal mux_acc_controle : unsigned(1 downto 0) := "00";
    signal mux_acc_entradazero : unsigned(15 downto 0) := "0000000000000000";
    signal mux_acc_entradaum : unsigned(15 downto 0) := "0000000000000000";
    signal mux_acc_entradadois : unsigned(15 downto 0) := "0000000000000000";
    signal mux_acc_saida : unsigned(15 downto 0):= "0000000000000000";

    signal ram_wr_en      : std_logic;
    signal ram_in         : unsigned (6 downto 0);
    signal ram_out        : unsigned (15 downto 0);

    component UC is
        port(
            instrucao : in unsigned(15 downto 0);
            rst : in std_logic;
            instrucao_branch : out std_logic;
            instrucao_jump : out std_logic;
            select_mux_pc : out unsigned(1 downto 0);
            wr_en_pc : out std_logic;
            select_ula_op : out unsigned(1 downto 0);
            select_mux_ula : out std_logic; 
            reg_wr_en : out std_logic; 
            selec_reg1 : out unsigned(2 downto 0);
            registrador_para_salvar : out unsigned(2 downto 0);
            select_mux_input_regs : out std_logic;
            acc_wr_en : out std_logic;
            select_mux_acc : out unsigned(1 downto 0);
            erro_instrucao : out unsigned(3 downto 0);
            brake : out std_logic;
            regflags_wr_en : out std_logic;
            regula_wr_en : out std_logic;
            ram_wr_en : out std_logic
        );
    end component;
    component constante is
        port(
            instrucao : in unsigned(15 downto 0);
            delta_salto_branch : out unsigned(6 downto 0);
            constante_saida : out unsigned(15 downto 0)
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
    component banco_de_registradores is
        port (  
            reg_select_1      : in unsigned(2 downto 0);
            reg_select_2      : in unsigned(2 downto 0);     
            regWrite          : in unsigned(2 downto 0);
            entr             : in unsigned(15 downto 0);
            wr_en             : in std_logic;
            clk               : in std_logic;
            rst               : in std_logic;
            reg_data1         : out unsigned(15 downto 0) := "0000000000000000";  
            reg_data2         : out unsigned(15 downto 0) := "0000000000000000" 
        );
    end component;
    component mutex16bits2vias
        port(
            controle : in std_logic := '0';
            entradazero : in unsigned(15 downto 0) := "0000000000000000";
            entradaum : in unsigned(15 downto 0) := "0000000000000000";
            saida : out unsigned(15 downto 0)
        );
    end component;
    component mutex16bits3vias
        port(
            controle : in unsigned(1 downto 0):= "00";
            entradazero : in unsigned(15 downto 0) := "0000000000000000";
            entradaum : in unsigned(15 downto 0) := "0000000000000000";
            entradadois : in unsigned(15 downto 0) := "0000000000000000";
            saida : out unsigned(15 downto 0) := "0000000000000000"
        );
    end component;
    component ram is
        port (
            clk      : in std_logic;
            endereco : in unsigned(6 downto 0);
            wr_en    : in std_logic;
            dado_in  : in unsigned(15 downto 0);
            dado_out : out unsigned(15 downto 0)
        );
    end component;

    begin
    UC_instance : UC port map(
        instrucao => UC_instrucao,
        rst => rst,
        instrucao_branch => UC_instrucao_branch,
        instrucao_jump => UC_instrucao_jump,
        select_mux_pc => select_mux_pc,
        wr_en_pc => wr_en_pc,
        select_ula_op => UC_select_ula_op,
        select_mux_ula => UC_select_mux_ula,
        reg_wr_en => UC_reg_wr_en,
        selec_reg1 => UC_selec_reg1,
        registrador_para_salvar => UC_registrador_para_salvar,
        select_mux_input_regs => UC_select_mux_regs,
        acc_wr_en => UC_acc_wr_en,
        select_mux_acc => UC_select_mux_acc,
        erro_instrucao => instrucao_erro,
        brake => brake,
        regflags_wr_en => UC_regflags_wr_en,
        regula_wr_en => UC_regula_wr_en,
        ram_wr_en => ram_wr_en
        );
    constante_instance : constante port map(
        instrucao => constante_instrucao,
        delta_salto_branch => constante_delta_salto_branch,
        constante_saida => constante_saida
        );


    acumulador_instance : reg16bits port map(
        clk => clk,
        rst => rst,
        wr_en => acc_wr_en,
        data_in => acc_data_in,
        data_out => acc_data_out
        );  

    banco_de_registradores_instance : banco_de_registradores port map(
        reg_select_1 => UC_selec_reg1,
        reg_select_2 => UC_selec_reg2,
        regWrite => UC_registrador_para_salvar,
        entr => reg_entr,
        wr_en => reg_wr_en,
        clk => clk,
        rst => rst,
        reg_data1 => reg_data1,
        reg_data2 => reg_data2
        );
    
    mutex_ula_instance : mutex16bits2vias port map(
        controle => mux_ula_controle,
        entradazero => mux_ula_entradazero,
        entradaum => mux_ula_entradaum,
        saida => mux_ula_saida
        );

    mutex_reg_instance : mutex16bits2vias port map(
        controle => mux_reg_controle,
        entradazero => mux_reg_entradazero,
        entradaum => mux_reg_entradaum, 
        saida => mux_reg_saida 
        );

    mutex_acc_instance : mutex16bits3vias port map(
        controle => mux_acc_controle,
        entradazero => mux_acc_entradazero,
        entradaum => mux_acc_entradaum,
        entradadois => mux_acc_entradadois,
        saida => mux_acc_saida
        );

    ram_instance: ram port map (
        clk      => clk,
        endereco => ram_in,
        wr_en    => ram_wr_en,
        dado_in  => reg_data2,
        dado_out => ram_out
        );
    
    
    reg_wr_en <= '1' when UC_reg_wr_en = '1' and estado = "10" else '0' ;
    acc_wr_en <= '1' when UC_acc_wr_en = '1' and estado = "10" else '0';
    regflags_wr_en <= '1' when UC_regflags_wr_en = '1' and estado = "00" else '0';
    regula_wr_en <= '1' when UC_regula_wr_en = '1' and estado = "00" else '0';
    -- conexao mutexes
        -- mutex acumulador
        mux_acc_controle <= UC_select_mux_acc;
        mux_acc_entradazero <= reg_data1;
        mux_acc_entradaum <= saida_ula;
        mux_acc_entradadois <= constante_saida;
        -- mutex ula
        mux_ula_controle <= UC_select_mux_ula;
        mux_ula_entradazero <= reg_data1;
        mux_ula_entradaum <= constante_saida;
        ina_ula <= mux_ula_saida;
        -- mutex reg
        mux_reg_controle <= UC_select_mux_regs;
        mux_reg_entradazero <= acc_data_out;
        mux_reg_entradaum <= constante_saida;
        reg_entr <= mux_reg_saida;
    
    -- conexao acumulador 
        acc_data_in <= mux_acc_saida;
        inb_ula <= acc_data_out;
    -- conexao Uni Controle
        UC_instrucao <= instrucao;
        select_op_ula <= UC_select_ula_op;
        -- UC_instrucao_beq
        instrucao_branch <= UC_instrucao_branch;
        instrucao_jump <= UC_instrucao_jump;
    -- conexoes constante
    reg_select_1 <= UC_selec_reg1;
    bit5 <= reg_data1(5);
    constante_instrucao <= instrucao;
    endereco_pc <= constante_delta_salto_branch;
    -- RAM
    ram_in <= reg_data2;


end architecture;