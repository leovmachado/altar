// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'Altar';

  @override
  String get appTagline => 'Sua igreja, lindamente organizada.';

  @override
  String get navHome => 'Início';

  @override
  String get navEvents => 'Eventos';

  @override
  String get navSchedule => 'Escala';

  @override
  String get navGiving => 'Doações';

  @override
  String get navProfile => 'Perfil';

  @override
  String get navDashboard => 'Painel';

  @override
  String get navPeople => 'Pessoas';

  @override
  String get navVisitorLeads => 'Visitantes';

  @override
  String get navEscala => 'Escala';

  @override
  String get navFinance => 'Finanças';

  @override
  String get navMedia => 'Mídia';

  @override
  String get navReports => 'Relatórios';

  @override
  String get navSettings => 'Configurações';

  @override
  String get actionSeeAll => 'Ver tudo';

  @override
  String get actionViewAll => 'Ver tudo';

  @override
  String get actionConfirm => 'Confirmar';

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionSave => 'Salvar';

  @override
  String get actionEdit => 'Editar';

  @override
  String get actionClose => 'Fechar';

  @override
  String get actionRetry => 'Tentar novamente';

  @override
  String get actionSearch => 'Buscar';

  @override
  String get actionShare => 'Compartilhar';

  @override
  String get actionContinue => 'Continuar';

  @override
  String get actionBack => 'Voltar';

  @override
  String get labelToday => 'Hoje';

  @override
  String get labelThisWeek => 'Esta semana';

  @override
  String get labelThisMonth => 'Este mês';

  @override
  String get labelUpcoming => 'Próximos';

  @override
  String get labelPast => 'Anteriores';

  @override
  String get authWelcome => 'Bem-vindo ao Altar';

  @override
  String get authSubtitle => 'Entre para continuar na sua igreja.';

  @override
  String get authEmail => 'E-mail';

  @override
  String get authEmailHint => 'voce@igreja.org';

  @override
  String get authPassword => 'Senha';

  @override
  String get authSignIn => 'Entrar';

  @override
  String get authForgotPassword => 'Esqueceu a senha?';

  @override
  String get authOrContinueWith => 'ou continue com';

  @override
  String get authGoogle => 'Continuar com Google';

  @override
  String get authApple => 'Continuar com Apple';

  @override
  String get authNoAccount => 'Não tem uma conta?';

  @override
  String get authSignUp => 'Cadastre-se';

  @override
  String get authMockNotice =>
      'Modo demo — a autenticação é simulada. Toque em qualquer opção para entrar.';

  @override
  String homeGreeting(String name) {
    return 'Olá, $name';
  }

  @override
  String get homeGoodMorning => 'Bom dia';

  @override
  String get homeGoodAfternoon => 'Boa tarde';

  @override
  String get homeGoodEvening => 'Boa noite';

  @override
  String get homeSpecialEvents => 'Eventos especiais';

  @override
  String get homeAnnouncements => 'Avisos';

  @override
  String get homeServingTitle => 'Você está escalado para servir';

  @override
  String homeServingBody(String role, String eventName, String date) {
    return '$role em $eventName · $date';
  }

  @override
  String get homeServingCta => 'Ver escala';

  @override
  String get homeQuickActions => 'Ações rápidas';

  @override
  String get homeQuickGive => 'Doar';

  @override
  String get homeQuickCheckIn => 'Check-in';

  @override
  String get homeQuickEvents => 'Eventos';

  @override
  String get homeQuickSchedule => 'Minha escala';

  @override
  String get homeGivingCardTitle => 'Sua generosidade';

  @override
  String get homeGivingCardSubtitle => 'Obrigado por doar este mês';

  @override
  String get homeGivingCardCta => 'Doar agora';

  @override
  String get homeForYou => 'Para você';

  @override
  String get eventsTitle => 'Eventos';

  @override
  String get eventsUpcoming => 'Próximos';

  @override
  String get eventsPast => 'Anteriores';

  @override
  String get eventsRegister => 'Inscrever-se';

  @override
  String get eventsRegistered => 'Inscrição confirmada';

  @override
  String get eventsDetails => 'Detalhes';

  @override
  String get eventsAbout => 'Sobre o evento';

  @override
  String get eventsLocation => 'Local';

  @override
  String get eventsWhen => 'Quando';

  @override
  String eventsAttendees(int count) {
    return '$count confirmados';
  }

  @override
  String get eventsRegistrationCta => 'Garantir minha vaga';

  @override
  String get eventsAddToCalendar => 'Adicionar à agenda';

  @override
  String eventsHosted(String ministry) {
    return 'Organizado por $ministry';
  }

  @override
  String get scheduleTitle => 'Escala';

  @override
  String get scheduleMyAssignments => 'Minhas escalas';

  @override
  String get scheduleAvailability => 'Disponibilidade';

  @override
  String get scheduleTeam => 'Equipe';

  @override
  String get scheduleConfirm => 'Confirmar';

  @override
  String get scheduleDecline => 'Recusar';

  @override
  String get scheduleConfirmed => 'Confirmado';

  @override
  String get schedulePending => 'Pendente';

  @override
  String get scheduleDeclined => 'Recusado';

  @override
  String get scheduleRoleLabel => 'Função';

  @override
  String get scheduleAvailablePrompt => 'Defina sua disponibilidade';

  @override
  String get scheduleAvailable => 'Disponível';

  @override
  String get scheduleUnavailable => 'Indisponível';

  @override
  String get scheduleLeaderEditor => 'Editor de escala';

  @override
  String get scheduleLeaderEditorSubtitle =>
      'Arraste voluntários para as funções e visualize antes de publicar.';

  @override
  String get schedulePreviewChanges => 'Visualizar alterações';

  @override
  String get schedulePublish => 'Publicar escala';

  @override
  String get scheduleUnassigned => 'Funções não atribuídas';

  @override
  String get scheduleDraft => 'Rascunho';

  @override
  String get scheduleNextServe => 'Próxima vez que você serve';

  @override
  String get givingTitle => 'Doações';

  @override
  String get givingGiveNow => 'Doar agora';

  @override
  String get givingAmount => 'Valor';

  @override
  String get givingFund => 'Fundo';

  @override
  String get givingFrequency => 'Frequência';

  @override
  String get givingOneTime => 'Única';

  @override
  String get givingMonthly => 'Mensal';

  @override
  String get givingFundGeneral => 'Fundo geral';

  @override
  String get givingFundMissions => 'Missões';

  @override
  String get givingFundBuilding => 'Construção';

  @override
  String get givingHistory => 'Histórico de doações';

  @override
  String get givingYearToDate => 'No ano';

  @override
  String get givingTaxStatement => 'Baixar comprovante fiscal';

  @override
  String get givingMethod => 'Forma de pagamento';

  @override
  String get givingSecure => 'Protegido pelo Altar · apenas demo';

  @override
  String get givingThisMonth => 'Doado este mês';

  @override
  String get givingRecurring => 'Doação recorrente';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profileFamily => 'Família';

  @override
  String get profileMinistries => 'Meus ministérios';

  @override
  String get profileLanguage => 'Idioma';

  @override
  String get profileSettings => 'Configurações';

  @override
  String get profileEdit => 'Editar perfil';

  @override
  String get profileNotifications => 'Notificações';

  @override
  String get profilePrivacy => 'Privacidade';

  @override
  String get profileHelp => 'Ajuda e suporte';

  @override
  String get profileSignOut => 'Sair';

  @override
  String get profileRoles => 'Funções';

  @override
  String profileMemberSince(String year) {
    return 'Membro desde $year';
  }

  @override
  String get languageEnglish => 'English';

  @override
  String get languagePortuguese => 'Português';

  @override
  String get languageSystem => 'Padrão do sistema';

  @override
  String get dashboardTitle => 'Painel';

  @override
  String dashWelcome(String name) {
    return 'Bem-vindo de volta, $name';
  }

  @override
  String get dashMembers => 'Membros';

  @override
  String get dashNewVisitors => 'Novos visitantes';

  @override
  String get dashGivingMonth => 'Doações do mês';

  @override
  String get dashUpcomingEvents => 'Próximos eventos';

  @override
  String get dashVolunteersScheduled => 'Voluntários escalados';

  @override
  String get dashAttendance => 'Presença média';

  @override
  String get dashGrowth => 'Crescimento';

  @override
  String get dashTeamHealth => 'Saúde da equipe';

  @override
  String get dashRecentActivity => 'Atividade recente';

  @override
  String get dashGivingTrend => 'Tendência de doações';

  @override
  String get dashServingThisWeek => 'Servindo esta semana';

  @override
  String get dashMyTeam => 'Minha equipe';

  @override
  String get dashOpenRoles => 'Funções abertas';

  @override
  String get dashBudgetUsed => 'Orçamento usado';

  @override
  String get dashPledges => 'Compromissos';

  @override
  String get dashVsLastMonth => 'vs mês anterior';

  @override
  String get roleSuperAdmin => 'Super Admin';

  @override
  String get roleLeadPastor => 'Pastor Titular';

  @override
  String get roleAdmin => 'Administrador';

  @override
  String get roleMinistryLeader => 'Líder de Ministério';

  @override
  String get roleVolunteer => 'Voluntário';

  @override
  String get roleMember => 'Membro';

  @override
  String get roleVisitor => 'Visitante';

  @override
  String get roleTreasurer => 'Tesoureiro';

  @override
  String get roleFinancialLeader => 'Líder Financeiro';

  @override
  String get roleMediaLeader => 'Líder de Mídia';

  @override
  String get comingSoonTitle => 'Em breve';

  @override
  String comingSoonBody(String module) {
    return '$module faz parte da plataforma Altar e estará disponível em uma fase posterior.';
  }

  @override
  String get emptyTitle => 'Nada por aqui ainda';

  @override
  String get emptyBody => 'Quando houver algo para mostrar, aparecerá aqui.';
}
