// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TaskTemplatesTable extends TaskTemplates
    with TableInfo<$TaskTemplatesTable, TaskTemplateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TaskCategory, String> category =
      GeneratedColumn<String>(
        'category',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TaskCategory>($TaskTemplatesTable.$convertercategory);
  @override
  late final GeneratedColumnWithTypeConverter<StatType, String> stat =
      GeneratedColumn<String>(
        'stat',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<StatType>($TaskTemplatesTable.$converterstat);
  @override
  late final GeneratedColumnWithTypeConverter<ScheduleType, String> schedule =
      GeneratedColumn<String>(
        'schedule',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ScheduleType>($TaskTemplatesTable.$converterschedule);
  @override
  late final GeneratedColumnWithTypeConverter<List<int>, String> daysOfWeek =
      GeneratedColumn<String>(
        'days_of_week',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      ).withConverter<List<int>>($TaskTemplatesTable.$converterdaysOfWeek);
  static const VerificationMeta _xpMeta = const VerificationMeta('xp');
  @override
  late final GeneratedColumn<int> xp = GeneratedColumn<int>(
    'xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledMinutesMeta = const VerificationMeta(
    'scheduledMinutes',
  );
  @override
  late final GeneratedColumn<int> scheduledMinutes = GeneratedColumn<int>(
    'scheduled_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _graceMinutesMeta = const VerificationMeta(
    'graceMinutes',
  );
  @override
  late final GeneratedColumn<int> graceMinutes = GeneratedColumn<int>(
    'grace_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(120),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    category,
    stat,
    schedule,
    daysOfWeek,
    xp,
    scheduledMinutes,
    graceMinutes,
    isActive,
    sortOrder,
    createdAt,
    archivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskTemplateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('xp')) {
      context.handle(_xpMeta, xp.isAcceptableOrUnknown(data['xp']!, _xpMeta));
    } else if (isInserting) {
      context.missing(_xpMeta);
    }
    if (data.containsKey('scheduled_minutes')) {
      context.handle(
        _scheduledMinutesMeta,
        scheduledMinutes.isAcceptableOrUnknown(
          data['scheduled_minutes']!,
          _scheduledMinutesMeta,
        ),
      );
    }
    if (data.containsKey('grace_minutes')) {
      context.handle(
        _graceMinutesMeta,
        graceMinutes.isAcceptableOrUnknown(
          data['grace_minutes']!,
          _graceMinutesMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskTemplateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskTemplateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      category: $TaskTemplatesTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}category'],
        )!,
      ),
      stat: $TaskTemplatesTable.$converterstat.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}stat'],
        )!,
      ),
      schedule: $TaskTemplatesTable.$converterschedule.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}schedule'],
        )!,
      ),
      daysOfWeek: $TaskTemplatesTable.$converterdaysOfWeek.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}days_of_week'],
        )!,
      ),
      xp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}xp'],
      )!,
      scheduledMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}scheduled_minutes'],
      ),
      graceMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}grace_minutes'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
    );
  }

  @override
  $TaskTemplatesTable createAlias(String alias) {
    return $TaskTemplatesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TaskCategory, String, String> $convertercategory =
      const EnumNameConverter<TaskCategory>(TaskCategory.values);
  static JsonTypeConverter2<StatType, String, String> $converterstat =
      const EnumNameConverter<StatType>(StatType.values);
  static JsonTypeConverter2<ScheduleType, String, String> $converterschedule =
      const EnumNameConverter<ScheduleType>(ScheduleType.values);
  static TypeConverter<List<int>, String> $converterdaysOfWeek =
      const DaysOfWeekConverter();
}

class TaskTemplateRow extends DataClass implements Insertable<TaskTemplateRow> {
  final String id;
  final String title;
  final TaskCategory category;
  final StatType stat;
  final ScheduleType schedule;
  final List<int> daysOfWeek;
  final int xp;

  /// When this step comes up, in minutes after local midnight (5:35am = 335).
  /// Null means "anytime today". Added in schema v3.
  final int? scheduledMinutes;

  /// How long the step stays answerable after its scheduled time.
  final int graceMinutes;
  final bool isActive;
  final int sortOrder;
  final DateTime createdAt;

  /// Templates are archived, never deleted — history rows still reference them.
  final DateTime? archivedAt;
  const TaskTemplateRow({
    required this.id,
    required this.title,
    required this.category,
    required this.stat,
    required this.schedule,
    required this.daysOfWeek,
    required this.xp,
    this.scheduledMinutes,
    required this.graceMinutes,
    required this.isActive,
    required this.sortOrder,
    required this.createdAt,
    this.archivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    {
      map['category'] = Variable<String>(
        $TaskTemplatesTable.$convertercategory.toSql(category),
      );
    }
    {
      map['stat'] = Variable<String>(
        $TaskTemplatesTable.$converterstat.toSql(stat),
      );
    }
    {
      map['schedule'] = Variable<String>(
        $TaskTemplatesTable.$converterschedule.toSql(schedule),
      );
    }
    {
      map['days_of_week'] = Variable<String>(
        $TaskTemplatesTable.$converterdaysOfWeek.toSql(daysOfWeek),
      );
    }
    map['xp'] = Variable<int>(xp);
    if (!nullToAbsent || scheduledMinutes != null) {
      map['scheduled_minutes'] = Variable<int>(scheduledMinutes);
    }
    map['grace_minutes'] = Variable<int>(graceMinutes);
    map['is_active'] = Variable<bool>(isActive);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    return map;
  }

  TaskTemplatesCompanion toCompanion(bool nullToAbsent) {
    return TaskTemplatesCompanion(
      id: Value(id),
      title: Value(title),
      category: Value(category),
      stat: Value(stat),
      schedule: Value(schedule),
      daysOfWeek: Value(daysOfWeek),
      xp: Value(xp),
      scheduledMinutes: scheduledMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduledMinutes),
      graceMinutes: Value(graceMinutes),
      isActive: Value(isActive),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
    );
  }

  factory TaskTemplateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskTemplateRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      category: $TaskTemplatesTable.$convertercategory.fromJson(
        serializer.fromJson<String>(json['category']),
      ),
      stat: $TaskTemplatesTable.$converterstat.fromJson(
        serializer.fromJson<String>(json['stat']),
      ),
      schedule: $TaskTemplatesTable.$converterschedule.fromJson(
        serializer.fromJson<String>(json['schedule']),
      ),
      daysOfWeek: serializer.fromJson<List<int>>(json['daysOfWeek']),
      xp: serializer.fromJson<int>(json['xp']),
      scheduledMinutes: serializer.fromJson<int?>(json['scheduledMinutes']),
      graceMinutes: serializer.fromJson<int>(json['graceMinutes']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'category': serializer.toJson<String>(
        $TaskTemplatesTable.$convertercategory.toJson(category),
      ),
      'stat': serializer.toJson<String>(
        $TaskTemplatesTable.$converterstat.toJson(stat),
      ),
      'schedule': serializer.toJson<String>(
        $TaskTemplatesTable.$converterschedule.toJson(schedule),
      ),
      'daysOfWeek': serializer.toJson<List<int>>(daysOfWeek),
      'xp': serializer.toJson<int>(xp),
      'scheduledMinutes': serializer.toJson<int?>(scheduledMinutes),
      'graceMinutes': serializer.toJson<int>(graceMinutes),
      'isActive': serializer.toJson<bool>(isActive),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
    };
  }

  TaskTemplateRow copyWith({
    String? id,
    String? title,
    TaskCategory? category,
    StatType? stat,
    ScheduleType? schedule,
    List<int>? daysOfWeek,
    int? xp,
    Value<int?> scheduledMinutes = const Value.absent(),
    int? graceMinutes,
    bool? isActive,
    int? sortOrder,
    DateTime? createdAt,
    Value<DateTime?> archivedAt = const Value.absent(),
  }) => TaskTemplateRow(
    id: id ?? this.id,
    title: title ?? this.title,
    category: category ?? this.category,
    stat: stat ?? this.stat,
    schedule: schedule ?? this.schedule,
    daysOfWeek: daysOfWeek ?? this.daysOfWeek,
    xp: xp ?? this.xp,
    scheduledMinutes: scheduledMinutes.present
        ? scheduledMinutes.value
        : this.scheduledMinutes,
    graceMinutes: graceMinutes ?? this.graceMinutes,
    isActive: isActive ?? this.isActive,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
  );
  TaskTemplateRow copyWithCompanion(TaskTemplatesCompanion data) {
    return TaskTemplateRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      category: data.category.present ? data.category.value : this.category,
      stat: data.stat.present ? data.stat.value : this.stat,
      schedule: data.schedule.present ? data.schedule.value : this.schedule,
      daysOfWeek: data.daysOfWeek.present
          ? data.daysOfWeek.value
          : this.daysOfWeek,
      xp: data.xp.present ? data.xp.value : this.xp,
      scheduledMinutes: data.scheduledMinutes.present
          ? data.scheduledMinutes.value
          : this.scheduledMinutes,
      graceMinutes: data.graceMinutes.present
          ? data.graceMinutes.value
          : this.graceMinutes,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskTemplateRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('stat: $stat, ')
          ..write('schedule: $schedule, ')
          ..write('daysOfWeek: $daysOfWeek, ')
          ..write('xp: $xp, ')
          ..write('scheduledMinutes: $scheduledMinutes, ')
          ..write('graceMinutes: $graceMinutes, ')
          ..write('isActive: $isActive, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    category,
    stat,
    schedule,
    daysOfWeek,
    xp,
    scheduledMinutes,
    graceMinutes,
    isActive,
    sortOrder,
    createdAt,
    archivedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskTemplateRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.category == this.category &&
          other.stat == this.stat &&
          other.schedule == this.schedule &&
          other.daysOfWeek == this.daysOfWeek &&
          other.xp == this.xp &&
          other.scheduledMinutes == this.scheduledMinutes &&
          other.graceMinutes == this.graceMinutes &&
          other.isActive == this.isActive &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.archivedAt == this.archivedAt);
}

class TaskTemplatesCompanion extends UpdateCompanion<TaskTemplateRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<TaskCategory> category;
  final Value<StatType> stat;
  final Value<ScheduleType> schedule;
  final Value<List<int>> daysOfWeek;
  final Value<int> xp;
  final Value<int?> scheduledMinutes;
  final Value<int> graceMinutes;
  final Value<bool> isActive;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime?> archivedAt;
  final Value<int> rowid;
  const TaskTemplatesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.category = const Value.absent(),
    this.stat = const Value.absent(),
    this.schedule = const Value.absent(),
    this.daysOfWeek = const Value.absent(),
    this.xp = const Value.absent(),
    this.scheduledMinutes = const Value.absent(),
    this.graceMinutes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskTemplatesCompanion.insert({
    required String id,
    required String title,
    required TaskCategory category,
    required StatType stat,
    required ScheduleType schedule,
    this.daysOfWeek = const Value.absent(),
    required int xp,
    this.scheduledMinutes = const Value.absent(),
    this.graceMinutes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       category = Value(category),
       stat = Value(stat),
       schedule = Value(schedule),
       xp = Value(xp),
       createdAt = Value(createdAt);
  static Insertable<TaskTemplateRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? category,
    Expression<String>? stat,
    Expression<String>? schedule,
    Expression<String>? daysOfWeek,
    Expression<int>? xp,
    Expression<int>? scheduledMinutes,
    Expression<int>? graceMinutes,
    Expression<bool>? isActive,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? archivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (category != null) 'category': category,
      if (stat != null) 'stat': stat,
      if (schedule != null) 'schedule': schedule,
      if (daysOfWeek != null) 'days_of_week': daysOfWeek,
      if (xp != null) 'xp': xp,
      if (scheduledMinutes != null) 'scheduled_minutes': scheduledMinutes,
      if (graceMinutes != null) 'grace_minutes': graceMinutes,
      if (isActive != null) 'is_active': isActive,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskTemplatesCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<TaskCategory>? category,
    Value<StatType>? stat,
    Value<ScheduleType>? schedule,
    Value<List<int>>? daysOfWeek,
    Value<int>? xp,
    Value<int?>? scheduledMinutes,
    Value<int>? graceMinutes,
    Value<bool>? isActive,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<DateTime?>? archivedAt,
    Value<int>? rowid,
  }) {
    return TaskTemplatesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      stat: stat ?? this.stat,
      schedule: schedule ?? this.schedule,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      xp: xp ?? this.xp,
      scheduledMinutes: scheduledMinutes ?? this.scheduledMinutes,
      graceMinutes: graceMinutes ?? this.graceMinutes,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      archivedAt: archivedAt ?? this.archivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(
        $TaskTemplatesTable.$convertercategory.toSql(category.value),
      );
    }
    if (stat.present) {
      map['stat'] = Variable<String>(
        $TaskTemplatesTable.$converterstat.toSql(stat.value),
      );
    }
    if (schedule.present) {
      map['schedule'] = Variable<String>(
        $TaskTemplatesTable.$converterschedule.toSql(schedule.value),
      );
    }
    if (daysOfWeek.present) {
      map['days_of_week'] = Variable<String>(
        $TaskTemplatesTable.$converterdaysOfWeek.toSql(daysOfWeek.value),
      );
    }
    if (xp.present) {
      map['xp'] = Variable<int>(xp.value);
    }
    if (scheduledMinutes.present) {
      map['scheduled_minutes'] = Variable<int>(scheduledMinutes.value);
    }
    if (graceMinutes.present) {
      map['grace_minutes'] = Variable<int>(graceMinutes.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('stat: $stat, ')
          ..write('schedule: $schedule, ')
          ..write('daysOfWeek: $daysOfWeek, ')
          ..write('xp: $xp, ')
          ..write('scheduledMinutes: $scheduledMinutes, ')
          ..write('graceMinutes: $graceMinutes, ')
          ..write('isActive: $isActive, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyQuestsTable extends DailyQuests
    with TableInfo<$DailyQuestsTable, DailyQuestRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyQuestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<String> templateId = GeneratedColumn<String>(
    'template_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES task_templates (id)',
    ),
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<int> day = GeneratedColumn<int>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<QuestStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('pending'),
      ).withConverter<QuestStatus>($DailyQuestsTable.$converterstatus);
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _xpAwardedMeta = const VerificationMeta(
    'xpAwarded',
  );
  @override
  late final GeneratedColumn<int> xpAwarded = GeneratedColumn<int>(
    'xp_awarded',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<StatType, String> stat =
      GeneratedColumn<String>(
        'stat',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<StatType>($DailyQuestsTable.$converterstat);
  static const VerificationMeta _scheduledMinutesMeta = const VerificationMeta(
    'scheduledMinutes',
  );
  @override
  late final GeneratedColumn<int> scheduledMinutes = GeneratedColumn<int>(
    'scheduled_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _graceMinutesMeta = const VerificationMeta(
    'graceMinutes',
  );
  @override
  late final GeneratedColumn<int> graceMinutes = GeneratedColumn<int>(
    'grace_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(120),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    templateId,
    day,
    status,
    completedAt,
    xpAwarded,
    stat,
    scheduledMinutes,
    graceMinutes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_quests';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyQuestRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    } else if (isInserting) {
      context.missing(_templateIdMeta);
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('xp_awarded')) {
      context.handle(
        _xpAwardedMeta,
        xpAwarded.isAcceptableOrUnknown(data['xp_awarded']!, _xpAwardedMeta),
      );
    } else if (isInserting) {
      context.missing(_xpAwardedMeta);
    }
    if (data.containsKey('scheduled_minutes')) {
      context.handle(
        _scheduledMinutesMeta,
        scheduledMinutes.isAcceptableOrUnknown(
          data['scheduled_minutes']!,
          _scheduledMinutesMeta,
        ),
      );
    }
    if (data.containsKey('grace_minutes')) {
      context.handle(
        _graceMinutesMeta,
        graceMinutes.isAcceptableOrUnknown(
          data['grace_minutes']!,
          _graceMinutesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {templateId, day},
  ];
  @override
  DailyQuestRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyQuestRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_id'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day'],
      )!,
      status: $DailyQuestsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      xpAwarded: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}xp_awarded'],
      )!,
      stat: $DailyQuestsTable.$converterstat.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}stat'],
        )!,
      ),
      scheduledMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}scheduled_minutes'],
      ),
      graceMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}grace_minutes'],
      )!,
    );
  }

  @override
  $DailyQuestsTable createAlias(String alias) {
    return $DailyQuestsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<QuestStatus, String, String> $converterstatus =
      const EnumNameConverter<QuestStatus>(QuestStatus.values);
  static JsonTypeConverter2<StatType, String, String> $converterstat =
      const EnumNameConverter<StatType>(StatType.values);
}

class DailyQuestRow extends DataClass implements Insertable<DailyQuestRow> {
  final int id;
  final String templateId;

  /// Integer day number — see lib/data/day_key.dart for why not a timestamp.
  final int day;

  /// pending | done | missed. Replaced the `done` boolean in schema v3:
  /// "not ticked yet" and "definitively missed" are different facts, and one
  /// bit cannot hold both.
  final QuestStatus status;
  final DateTime? completedAt;

  /// Snapshots taken at issue time, NOT live lookups through the template.
  /// The timings are snapshotted for the same reason the XP is: re-timing a
  /// template must not retroactively change whether last Tuesday's step
  /// lapsed.
  final int xpAwarded;
  final StatType stat;
  final int? scheduledMinutes;
  final int graceMinutes;
  const DailyQuestRow({
    required this.id,
    required this.templateId,
    required this.day,
    required this.status,
    this.completedAt,
    required this.xpAwarded,
    required this.stat,
    this.scheduledMinutes,
    required this.graceMinutes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['template_id'] = Variable<String>(templateId);
    map['day'] = Variable<int>(day);
    {
      map['status'] = Variable<String>(
        $DailyQuestsTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['xp_awarded'] = Variable<int>(xpAwarded);
    {
      map['stat'] = Variable<String>(
        $DailyQuestsTable.$converterstat.toSql(stat),
      );
    }
    if (!nullToAbsent || scheduledMinutes != null) {
      map['scheduled_minutes'] = Variable<int>(scheduledMinutes);
    }
    map['grace_minutes'] = Variable<int>(graceMinutes);
    return map;
  }

  DailyQuestsCompanion toCompanion(bool nullToAbsent) {
    return DailyQuestsCompanion(
      id: Value(id),
      templateId: Value(templateId),
      day: Value(day),
      status: Value(status),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      xpAwarded: Value(xpAwarded),
      stat: Value(stat),
      scheduledMinutes: scheduledMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduledMinutes),
      graceMinutes: Value(graceMinutes),
    );
  }

  factory DailyQuestRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyQuestRow(
      id: serializer.fromJson<int>(json['id']),
      templateId: serializer.fromJson<String>(json['templateId']),
      day: serializer.fromJson<int>(json['day']),
      status: $DailyQuestsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      xpAwarded: serializer.fromJson<int>(json['xpAwarded']),
      stat: $DailyQuestsTable.$converterstat.fromJson(
        serializer.fromJson<String>(json['stat']),
      ),
      scheduledMinutes: serializer.fromJson<int?>(json['scheduledMinutes']),
      graceMinutes: serializer.fromJson<int>(json['graceMinutes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'templateId': serializer.toJson<String>(templateId),
      'day': serializer.toJson<int>(day),
      'status': serializer.toJson<String>(
        $DailyQuestsTable.$converterstatus.toJson(status),
      ),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'xpAwarded': serializer.toJson<int>(xpAwarded),
      'stat': serializer.toJson<String>(
        $DailyQuestsTable.$converterstat.toJson(stat),
      ),
      'scheduledMinutes': serializer.toJson<int?>(scheduledMinutes),
      'graceMinutes': serializer.toJson<int>(graceMinutes),
    };
  }

  DailyQuestRow copyWith({
    int? id,
    String? templateId,
    int? day,
    QuestStatus? status,
    Value<DateTime?> completedAt = const Value.absent(),
    int? xpAwarded,
    StatType? stat,
    Value<int?> scheduledMinutes = const Value.absent(),
    int? graceMinutes,
  }) => DailyQuestRow(
    id: id ?? this.id,
    templateId: templateId ?? this.templateId,
    day: day ?? this.day,
    status: status ?? this.status,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    xpAwarded: xpAwarded ?? this.xpAwarded,
    stat: stat ?? this.stat,
    scheduledMinutes: scheduledMinutes.present
        ? scheduledMinutes.value
        : this.scheduledMinutes,
    graceMinutes: graceMinutes ?? this.graceMinutes,
  );
  DailyQuestRow copyWithCompanion(DailyQuestsCompanion data) {
    return DailyQuestRow(
      id: data.id.present ? data.id.value : this.id,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      day: data.day.present ? data.day.value : this.day,
      status: data.status.present ? data.status.value : this.status,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      xpAwarded: data.xpAwarded.present ? data.xpAwarded.value : this.xpAwarded,
      stat: data.stat.present ? data.stat.value : this.stat,
      scheduledMinutes: data.scheduledMinutes.present
          ? data.scheduledMinutes.value
          : this.scheduledMinutes,
      graceMinutes: data.graceMinutes.present
          ? data.graceMinutes.value
          : this.graceMinutes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyQuestRow(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('day: $day, ')
          ..write('status: $status, ')
          ..write('completedAt: $completedAt, ')
          ..write('xpAwarded: $xpAwarded, ')
          ..write('stat: $stat, ')
          ..write('scheduledMinutes: $scheduledMinutes, ')
          ..write('graceMinutes: $graceMinutes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    templateId,
    day,
    status,
    completedAt,
    xpAwarded,
    stat,
    scheduledMinutes,
    graceMinutes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyQuestRow &&
          other.id == this.id &&
          other.templateId == this.templateId &&
          other.day == this.day &&
          other.status == this.status &&
          other.completedAt == this.completedAt &&
          other.xpAwarded == this.xpAwarded &&
          other.stat == this.stat &&
          other.scheduledMinutes == this.scheduledMinutes &&
          other.graceMinutes == this.graceMinutes);
}

class DailyQuestsCompanion extends UpdateCompanion<DailyQuestRow> {
  final Value<int> id;
  final Value<String> templateId;
  final Value<int> day;
  final Value<QuestStatus> status;
  final Value<DateTime?> completedAt;
  final Value<int> xpAwarded;
  final Value<StatType> stat;
  final Value<int?> scheduledMinutes;
  final Value<int> graceMinutes;
  const DailyQuestsCompanion({
    this.id = const Value.absent(),
    this.templateId = const Value.absent(),
    this.day = const Value.absent(),
    this.status = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.xpAwarded = const Value.absent(),
    this.stat = const Value.absent(),
    this.scheduledMinutes = const Value.absent(),
    this.graceMinutes = const Value.absent(),
  });
  DailyQuestsCompanion.insert({
    this.id = const Value.absent(),
    required String templateId,
    required int day,
    this.status = const Value.absent(),
    this.completedAt = const Value.absent(),
    required int xpAwarded,
    required StatType stat,
    this.scheduledMinutes = const Value.absent(),
    this.graceMinutes = const Value.absent(),
  }) : templateId = Value(templateId),
       day = Value(day),
       xpAwarded = Value(xpAwarded),
       stat = Value(stat);
  static Insertable<DailyQuestRow> custom({
    Expression<int>? id,
    Expression<String>? templateId,
    Expression<int>? day,
    Expression<String>? status,
    Expression<DateTime>? completedAt,
    Expression<int>? xpAwarded,
    Expression<String>? stat,
    Expression<int>? scheduledMinutes,
    Expression<int>? graceMinutes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (templateId != null) 'template_id': templateId,
      if (day != null) 'day': day,
      if (status != null) 'status': status,
      if (completedAt != null) 'completed_at': completedAt,
      if (xpAwarded != null) 'xp_awarded': xpAwarded,
      if (stat != null) 'stat': stat,
      if (scheduledMinutes != null) 'scheduled_minutes': scheduledMinutes,
      if (graceMinutes != null) 'grace_minutes': graceMinutes,
    });
  }

  DailyQuestsCompanion copyWith({
    Value<int>? id,
    Value<String>? templateId,
    Value<int>? day,
    Value<QuestStatus>? status,
    Value<DateTime?>? completedAt,
    Value<int>? xpAwarded,
    Value<StatType>? stat,
    Value<int?>? scheduledMinutes,
    Value<int>? graceMinutes,
  }) {
    return DailyQuestsCompanion(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      day: day ?? this.day,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
      xpAwarded: xpAwarded ?? this.xpAwarded,
      stat: stat ?? this.stat,
      scheduledMinutes: scheduledMinutes ?? this.scheduledMinutes,
      graceMinutes: graceMinutes ?? this.graceMinutes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<String>(templateId.value);
    }
    if (day.present) {
      map['day'] = Variable<int>(day.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $DailyQuestsTable.$converterstatus.toSql(status.value),
      );
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (xpAwarded.present) {
      map['xp_awarded'] = Variable<int>(xpAwarded.value);
    }
    if (stat.present) {
      map['stat'] = Variable<String>(
        $DailyQuestsTable.$converterstat.toSql(stat.value),
      );
    }
    if (scheduledMinutes.present) {
      map['scheduled_minutes'] = Variable<int>(scheduledMinutes.value);
    }
    if (graceMinutes.present) {
      map['grace_minutes'] = Variable<int>(graceMinutes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyQuestsCompanion(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('day: $day, ')
          ..write('status: $status, ')
          ..write('completedAt: $completedAt, ')
          ..write('xpAwarded: $xpAwarded, ')
          ..write('stat: $stat, ')
          ..write('scheduledMinutes: $scheduledMinutes, ')
          ..write('graceMinutes: $graceMinutes')
          ..write(')'))
        .toString();
  }
}

class $DayRollupsTable extends DayRollups
    with TableInfo<$DayRollupsTable, DayRollupRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DayRollupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<int> day = GeneratedColumn<int>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _xpEarnedMeta = const VerificationMeta(
    'xpEarned',
  );
  @override
  late final GeneratedColumn<int> xpEarned = GeneratedColumn<int>(
    'xp_earned',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _xpAvailableMeta = const VerificationMeta(
    'xpAvailable',
  );
  @override
  late final GeneratedColumn<int> xpAvailable = GeneratedColumn<int>(
    'xp_available',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _questsClearedMeta = const VerificationMeta(
    'questsCleared',
  );
  @override
  late final GeneratedColumn<int> questsCleared = GeneratedColumn<int>(
    'quests_cleared',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _questsMissedMeta = const VerificationMeta(
    'questsMissed',
  );
  @override
  late final GeneratedColumn<int> questsMissed = GeneratedColumn<int>(
    'quests_missed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _questsTotalMeta = const VerificationMeta(
    'questsTotal',
  );
  @override
  late final GeneratedColumn<int> questsTotal = GeneratedColumn<int>(
    'quests_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isPerfectMeta = const VerificationMeta(
    'isPerfect',
  );
  @override
  late final GeneratedColumn<bool> isPerfect = GeneratedColumn<bool>(
    'is_perfect',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_perfect" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _strXpMeta = const VerificationMeta('strXp');
  @override
  late final GeneratedColumn<int> strXp = GeneratedColumn<int>(
    'str_xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _staXpMeta = const VerificationMeta('staXp');
  @override
  late final GeneratedColumn<int> staXp = GeneratedColumn<int>(
    'sta_xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _disXpMeta = const VerificationMeta('disXp');
  @override
  late final GeneratedColumn<int> disXp = GeneratedColumn<int>(
    'dis_xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _recXpMeta = const VerificationMeta('recXp');
  @override
  late final GeneratedColumn<int> recXp = GeneratedColumn<int>(
    'rec_xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    day,
    xpEarned,
    xpAvailable,
    questsCleared,
    questsMissed,
    questsTotal,
    isPerfect,
    strXp,
    staXp,
    disXp,
    recXp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'day_rollups';
  @override
  VerificationContext validateIntegrity(
    Insertable<DayRollupRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    }
    if (data.containsKey('xp_earned')) {
      context.handle(
        _xpEarnedMeta,
        xpEarned.isAcceptableOrUnknown(data['xp_earned']!, _xpEarnedMeta),
      );
    }
    if (data.containsKey('xp_available')) {
      context.handle(
        _xpAvailableMeta,
        xpAvailable.isAcceptableOrUnknown(
          data['xp_available']!,
          _xpAvailableMeta,
        ),
      );
    }
    if (data.containsKey('quests_cleared')) {
      context.handle(
        _questsClearedMeta,
        questsCleared.isAcceptableOrUnknown(
          data['quests_cleared']!,
          _questsClearedMeta,
        ),
      );
    }
    if (data.containsKey('quests_missed')) {
      context.handle(
        _questsMissedMeta,
        questsMissed.isAcceptableOrUnknown(
          data['quests_missed']!,
          _questsMissedMeta,
        ),
      );
    }
    if (data.containsKey('quests_total')) {
      context.handle(
        _questsTotalMeta,
        questsTotal.isAcceptableOrUnknown(
          data['quests_total']!,
          _questsTotalMeta,
        ),
      );
    }
    if (data.containsKey('is_perfect')) {
      context.handle(
        _isPerfectMeta,
        isPerfect.isAcceptableOrUnknown(data['is_perfect']!, _isPerfectMeta),
      );
    }
    if (data.containsKey('str_xp')) {
      context.handle(
        _strXpMeta,
        strXp.isAcceptableOrUnknown(data['str_xp']!, _strXpMeta),
      );
    }
    if (data.containsKey('sta_xp')) {
      context.handle(
        _staXpMeta,
        staXp.isAcceptableOrUnknown(data['sta_xp']!, _staXpMeta),
      );
    }
    if (data.containsKey('dis_xp')) {
      context.handle(
        _disXpMeta,
        disXp.isAcceptableOrUnknown(data['dis_xp']!, _disXpMeta),
      );
    }
    if (data.containsKey('rec_xp')) {
      context.handle(
        _recXpMeta,
        recXp.isAcceptableOrUnknown(data['rec_xp']!, _recXpMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {day};
  @override
  DayRollupRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DayRollupRow(
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day'],
      )!,
      xpEarned: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}xp_earned'],
      )!,
      xpAvailable: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}xp_available'],
      )!,
      questsCleared: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quests_cleared'],
      )!,
      questsMissed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quests_missed'],
      )!,
      questsTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quests_total'],
      )!,
      isPerfect: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_perfect'],
      )!,
      strXp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}str_xp'],
      )!,
      staXp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sta_xp'],
      )!,
      disXp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dis_xp'],
      )!,
      recXp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rec_xp'],
      )!,
    );
  }

  @override
  $DayRollupsTable createAlias(String alias) {
    return $DayRollupsTable(attachedDatabase, alias);
  }
}

class DayRollupRow extends DataClass implements Insertable<DayRollupRow> {
  final int day;
  final int xpEarned;
  final int xpAvailable;
  final int questsCleared;

  /// Steps that ended the day unanswered or answered as missed. Added in
  /// schema v3 so the weekly report can show misses without rescanning every
  /// quest row.
  final int questsMissed;
  final int questsTotal;
  final bool isPerfect;
  final int strXp;
  final int staXp;
  final int disXp;
  final int recXp;
  const DayRollupRow({
    required this.day,
    required this.xpEarned,
    required this.xpAvailable,
    required this.questsCleared,
    required this.questsMissed,
    required this.questsTotal,
    required this.isPerfect,
    required this.strXp,
    required this.staXp,
    required this.disXp,
    required this.recXp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['day'] = Variable<int>(day);
    map['xp_earned'] = Variable<int>(xpEarned);
    map['xp_available'] = Variable<int>(xpAvailable);
    map['quests_cleared'] = Variable<int>(questsCleared);
    map['quests_missed'] = Variable<int>(questsMissed);
    map['quests_total'] = Variable<int>(questsTotal);
    map['is_perfect'] = Variable<bool>(isPerfect);
    map['str_xp'] = Variable<int>(strXp);
    map['sta_xp'] = Variable<int>(staXp);
    map['dis_xp'] = Variable<int>(disXp);
    map['rec_xp'] = Variable<int>(recXp);
    return map;
  }

  DayRollupsCompanion toCompanion(bool nullToAbsent) {
    return DayRollupsCompanion(
      day: Value(day),
      xpEarned: Value(xpEarned),
      xpAvailable: Value(xpAvailable),
      questsCleared: Value(questsCleared),
      questsMissed: Value(questsMissed),
      questsTotal: Value(questsTotal),
      isPerfect: Value(isPerfect),
      strXp: Value(strXp),
      staXp: Value(staXp),
      disXp: Value(disXp),
      recXp: Value(recXp),
    );
  }

  factory DayRollupRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DayRollupRow(
      day: serializer.fromJson<int>(json['day']),
      xpEarned: serializer.fromJson<int>(json['xpEarned']),
      xpAvailable: serializer.fromJson<int>(json['xpAvailable']),
      questsCleared: serializer.fromJson<int>(json['questsCleared']),
      questsMissed: serializer.fromJson<int>(json['questsMissed']),
      questsTotal: serializer.fromJson<int>(json['questsTotal']),
      isPerfect: serializer.fromJson<bool>(json['isPerfect']),
      strXp: serializer.fromJson<int>(json['strXp']),
      staXp: serializer.fromJson<int>(json['staXp']),
      disXp: serializer.fromJson<int>(json['disXp']),
      recXp: serializer.fromJson<int>(json['recXp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'day': serializer.toJson<int>(day),
      'xpEarned': serializer.toJson<int>(xpEarned),
      'xpAvailable': serializer.toJson<int>(xpAvailable),
      'questsCleared': serializer.toJson<int>(questsCleared),
      'questsMissed': serializer.toJson<int>(questsMissed),
      'questsTotal': serializer.toJson<int>(questsTotal),
      'isPerfect': serializer.toJson<bool>(isPerfect),
      'strXp': serializer.toJson<int>(strXp),
      'staXp': serializer.toJson<int>(staXp),
      'disXp': serializer.toJson<int>(disXp),
      'recXp': serializer.toJson<int>(recXp),
    };
  }

  DayRollupRow copyWith({
    int? day,
    int? xpEarned,
    int? xpAvailable,
    int? questsCleared,
    int? questsMissed,
    int? questsTotal,
    bool? isPerfect,
    int? strXp,
    int? staXp,
    int? disXp,
    int? recXp,
  }) => DayRollupRow(
    day: day ?? this.day,
    xpEarned: xpEarned ?? this.xpEarned,
    xpAvailable: xpAvailable ?? this.xpAvailable,
    questsCleared: questsCleared ?? this.questsCleared,
    questsMissed: questsMissed ?? this.questsMissed,
    questsTotal: questsTotal ?? this.questsTotal,
    isPerfect: isPerfect ?? this.isPerfect,
    strXp: strXp ?? this.strXp,
    staXp: staXp ?? this.staXp,
    disXp: disXp ?? this.disXp,
    recXp: recXp ?? this.recXp,
  );
  DayRollupRow copyWithCompanion(DayRollupsCompanion data) {
    return DayRollupRow(
      day: data.day.present ? data.day.value : this.day,
      xpEarned: data.xpEarned.present ? data.xpEarned.value : this.xpEarned,
      xpAvailable: data.xpAvailable.present
          ? data.xpAvailable.value
          : this.xpAvailable,
      questsCleared: data.questsCleared.present
          ? data.questsCleared.value
          : this.questsCleared,
      questsMissed: data.questsMissed.present
          ? data.questsMissed.value
          : this.questsMissed,
      questsTotal: data.questsTotal.present
          ? data.questsTotal.value
          : this.questsTotal,
      isPerfect: data.isPerfect.present ? data.isPerfect.value : this.isPerfect,
      strXp: data.strXp.present ? data.strXp.value : this.strXp,
      staXp: data.staXp.present ? data.staXp.value : this.staXp,
      disXp: data.disXp.present ? data.disXp.value : this.disXp,
      recXp: data.recXp.present ? data.recXp.value : this.recXp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DayRollupRow(')
          ..write('day: $day, ')
          ..write('xpEarned: $xpEarned, ')
          ..write('xpAvailable: $xpAvailable, ')
          ..write('questsCleared: $questsCleared, ')
          ..write('questsMissed: $questsMissed, ')
          ..write('questsTotal: $questsTotal, ')
          ..write('isPerfect: $isPerfect, ')
          ..write('strXp: $strXp, ')
          ..write('staXp: $staXp, ')
          ..write('disXp: $disXp, ')
          ..write('recXp: $recXp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    day,
    xpEarned,
    xpAvailable,
    questsCleared,
    questsMissed,
    questsTotal,
    isPerfect,
    strXp,
    staXp,
    disXp,
    recXp,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DayRollupRow &&
          other.day == this.day &&
          other.xpEarned == this.xpEarned &&
          other.xpAvailable == this.xpAvailable &&
          other.questsCleared == this.questsCleared &&
          other.questsMissed == this.questsMissed &&
          other.questsTotal == this.questsTotal &&
          other.isPerfect == this.isPerfect &&
          other.strXp == this.strXp &&
          other.staXp == this.staXp &&
          other.disXp == this.disXp &&
          other.recXp == this.recXp);
}

class DayRollupsCompanion extends UpdateCompanion<DayRollupRow> {
  final Value<int> day;
  final Value<int> xpEarned;
  final Value<int> xpAvailable;
  final Value<int> questsCleared;
  final Value<int> questsMissed;
  final Value<int> questsTotal;
  final Value<bool> isPerfect;
  final Value<int> strXp;
  final Value<int> staXp;
  final Value<int> disXp;
  final Value<int> recXp;
  const DayRollupsCompanion({
    this.day = const Value.absent(),
    this.xpEarned = const Value.absent(),
    this.xpAvailable = const Value.absent(),
    this.questsCleared = const Value.absent(),
    this.questsMissed = const Value.absent(),
    this.questsTotal = const Value.absent(),
    this.isPerfect = const Value.absent(),
    this.strXp = const Value.absent(),
    this.staXp = const Value.absent(),
    this.disXp = const Value.absent(),
    this.recXp = const Value.absent(),
  });
  DayRollupsCompanion.insert({
    this.day = const Value.absent(),
    this.xpEarned = const Value.absent(),
    this.xpAvailable = const Value.absent(),
    this.questsCleared = const Value.absent(),
    this.questsMissed = const Value.absent(),
    this.questsTotal = const Value.absent(),
    this.isPerfect = const Value.absent(),
    this.strXp = const Value.absent(),
    this.staXp = const Value.absent(),
    this.disXp = const Value.absent(),
    this.recXp = const Value.absent(),
  });
  static Insertable<DayRollupRow> custom({
    Expression<int>? day,
    Expression<int>? xpEarned,
    Expression<int>? xpAvailable,
    Expression<int>? questsCleared,
    Expression<int>? questsMissed,
    Expression<int>? questsTotal,
    Expression<bool>? isPerfect,
    Expression<int>? strXp,
    Expression<int>? staXp,
    Expression<int>? disXp,
    Expression<int>? recXp,
  }) {
    return RawValuesInsertable({
      if (day != null) 'day': day,
      if (xpEarned != null) 'xp_earned': xpEarned,
      if (xpAvailable != null) 'xp_available': xpAvailable,
      if (questsCleared != null) 'quests_cleared': questsCleared,
      if (questsMissed != null) 'quests_missed': questsMissed,
      if (questsTotal != null) 'quests_total': questsTotal,
      if (isPerfect != null) 'is_perfect': isPerfect,
      if (strXp != null) 'str_xp': strXp,
      if (staXp != null) 'sta_xp': staXp,
      if (disXp != null) 'dis_xp': disXp,
      if (recXp != null) 'rec_xp': recXp,
    });
  }

  DayRollupsCompanion copyWith({
    Value<int>? day,
    Value<int>? xpEarned,
    Value<int>? xpAvailable,
    Value<int>? questsCleared,
    Value<int>? questsMissed,
    Value<int>? questsTotal,
    Value<bool>? isPerfect,
    Value<int>? strXp,
    Value<int>? staXp,
    Value<int>? disXp,
    Value<int>? recXp,
  }) {
    return DayRollupsCompanion(
      day: day ?? this.day,
      xpEarned: xpEarned ?? this.xpEarned,
      xpAvailable: xpAvailable ?? this.xpAvailable,
      questsCleared: questsCleared ?? this.questsCleared,
      questsMissed: questsMissed ?? this.questsMissed,
      questsTotal: questsTotal ?? this.questsTotal,
      isPerfect: isPerfect ?? this.isPerfect,
      strXp: strXp ?? this.strXp,
      staXp: staXp ?? this.staXp,
      disXp: disXp ?? this.disXp,
      recXp: recXp ?? this.recXp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (day.present) {
      map['day'] = Variable<int>(day.value);
    }
    if (xpEarned.present) {
      map['xp_earned'] = Variable<int>(xpEarned.value);
    }
    if (xpAvailable.present) {
      map['xp_available'] = Variable<int>(xpAvailable.value);
    }
    if (questsCleared.present) {
      map['quests_cleared'] = Variable<int>(questsCleared.value);
    }
    if (questsMissed.present) {
      map['quests_missed'] = Variable<int>(questsMissed.value);
    }
    if (questsTotal.present) {
      map['quests_total'] = Variable<int>(questsTotal.value);
    }
    if (isPerfect.present) {
      map['is_perfect'] = Variable<bool>(isPerfect.value);
    }
    if (strXp.present) {
      map['str_xp'] = Variable<int>(strXp.value);
    }
    if (staXp.present) {
      map['sta_xp'] = Variable<int>(staXp.value);
    }
    if (disXp.present) {
      map['dis_xp'] = Variable<int>(disXp.value);
    }
    if (recXp.present) {
      map['rec_xp'] = Variable<int>(recXp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DayRollupsCompanion(')
          ..write('day: $day, ')
          ..write('xpEarned: $xpEarned, ')
          ..write('xpAvailable: $xpAvailable, ')
          ..write('questsCleared: $questsCleared, ')
          ..write('questsMissed: $questsMissed, ')
          ..write('questsTotal: $questsTotal, ')
          ..write('isPerfect: $isPerfect, ')
          ..write('strXp: $strXp, ')
          ..write('staXp: $staXp, ')
          ..write('disXp: $disXp, ')
          ..write('recXp: $recXp')
          ..write(')'))
        .toString();
  }
}

class $PlayerStatesTable extends PlayerStates
    with TableInfo<$PlayerStatesTable, PlayerStateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayerStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _hunterNameMeta = const VerificationMeta(
    'hunterName',
  );
  @override
  late final GeneratedColumn<String> hunterName = GeneratedColumn<String>(
    'hunter_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('HUNTER'),
  );
  static const VerificationMeta _totalXpMeta = const VerificationMeta(
    'totalXp',
  );
  @override
  late final GeneratedColumn<int> totalXp = GeneratedColumn<int>(
    'total_xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _strXpMeta = const VerificationMeta('strXp');
  @override
  late final GeneratedColumn<int> strXp = GeneratedColumn<int>(
    'str_xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _staXpMeta = const VerificationMeta('staXp');
  @override
  late final GeneratedColumn<int> staXp = GeneratedColumn<int>(
    'sta_xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _disXpMeta = const VerificationMeta('disXp');
  @override
  late final GeneratedColumn<int> disXp = GeneratedColumn<int>(
    'dis_xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _recXpMeta = const VerificationMeta('recXp');
  @override
  late final GeneratedColumn<int> recXp = GeneratedColumn<int>(
    'rec_xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currentStreakMeta = const VerificationMeta(
    'currentStreak',
  );
  @override
  late final GeneratedColumn<int> currentStreak = GeneratedColumn<int>(
    'current_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _longestStreakMeta = const VerificationMeta(
    'longestStreak',
  );
  @override
  late final GeneratedColumn<int> longestStreak = GeneratedColumn<int>(
    'longest_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _perfectDaysMeta = const VerificationMeta(
    'perfectDays',
  );
  @override
  late final GeneratedColumn<int> perfectDays = GeneratedColumn<int>(
    'perfect_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastActiveDayMeta = const VerificationMeta(
    'lastActiveDay',
  );
  @override
  late final GeneratedColumn<int> lastActiveDay = GeneratedColumn<int>(
    'last_active_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _acknowledgedLevelMeta = const VerificationMeta(
    'acknowledgedLevel',
  );
  @override
  late final GeneratedColumn<int> acknowledgedLevel = GeneratedColumn<int>(
    'acknowledged_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _acknowledgedRankMeta = const VerificationMeta(
    'acknowledgedRank',
  );
  @override
  late final GeneratedColumn<String> acknowledgedRank = GeneratedColumn<String>(
    'acknowledged_rank',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('E'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    hunterName,
    totalXp,
    strXp,
    staXp,
    disXp,
    recXp,
    currentStreak,
    longestStreak,
    perfectDays,
    lastActiveDay,
    acknowledgedLevel,
    acknowledgedRank,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'player_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlayerStateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('hunter_name')) {
      context.handle(
        _hunterNameMeta,
        hunterName.isAcceptableOrUnknown(data['hunter_name']!, _hunterNameMeta),
      );
    }
    if (data.containsKey('total_xp')) {
      context.handle(
        _totalXpMeta,
        totalXp.isAcceptableOrUnknown(data['total_xp']!, _totalXpMeta),
      );
    }
    if (data.containsKey('str_xp')) {
      context.handle(
        _strXpMeta,
        strXp.isAcceptableOrUnknown(data['str_xp']!, _strXpMeta),
      );
    }
    if (data.containsKey('sta_xp')) {
      context.handle(
        _staXpMeta,
        staXp.isAcceptableOrUnknown(data['sta_xp']!, _staXpMeta),
      );
    }
    if (data.containsKey('dis_xp')) {
      context.handle(
        _disXpMeta,
        disXp.isAcceptableOrUnknown(data['dis_xp']!, _disXpMeta),
      );
    }
    if (data.containsKey('rec_xp')) {
      context.handle(
        _recXpMeta,
        recXp.isAcceptableOrUnknown(data['rec_xp']!, _recXpMeta),
      );
    }
    if (data.containsKey('current_streak')) {
      context.handle(
        _currentStreakMeta,
        currentStreak.isAcceptableOrUnknown(
          data['current_streak']!,
          _currentStreakMeta,
        ),
      );
    }
    if (data.containsKey('longest_streak')) {
      context.handle(
        _longestStreakMeta,
        longestStreak.isAcceptableOrUnknown(
          data['longest_streak']!,
          _longestStreakMeta,
        ),
      );
    }
    if (data.containsKey('perfect_days')) {
      context.handle(
        _perfectDaysMeta,
        perfectDays.isAcceptableOrUnknown(
          data['perfect_days']!,
          _perfectDaysMeta,
        ),
      );
    }
    if (data.containsKey('last_active_day')) {
      context.handle(
        _lastActiveDayMeta,
        lastActiveDay.isAcceptableOrUnknown(
          data['last_active_day']!,
          _lastActiveDayMeta,
        ),
      );
    }
    if (data.containsKey('acknowledged_level')) {
      context.handle(
        _acknowledgedLevelMeta,
        acknowledgedLevel.isAcceptableOrUnknown(
          data['acknowledged_level']!,
          _acknowledgedLevelMeta,
        ),
      );
    }
    if (data.containsKey('acknowledged_rank')) {
      context.handle(
        _acknowledgedRankMeta,
        acknowledgedRank.isAcceptableOrUnknown(
          data['acknowledged_rank']!,
          _acknowledgedRankMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlayerStateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlayerStateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      hunterName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hunter_name'],
      )!,
      totalXp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_xp'],
      )!,
      strXp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}str_xp'],
      )!,
      staXp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sta_xp'],
      )!,
      disXp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dis_xp'],
      )!,
      recXp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rec_xp'],
      )!,
      currentStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_streak'],
      )!,
      longestStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}longest_streak'],
      )!,
      perfectDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}perfect_days'],
      )!,
      lastActiveDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_active_day'],
      ),
      acknowledgedLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}acknowledged_level'],
      )!,
      acknowledgedRank: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}acknowledged_rank'],
      )!,
    );
  }

  @override
  $PlayerStatesTable createAlias(String alias) {
    return $PlayerStatesTable(attachedDatabase, alias);
  }
}

class PlayerStateRow extends DataClass implements Insertable<PlayerStateRow> {
  final int id;
  final String hunterName;
  final int totalXp;
  final int strXp;
  final int staXp;
  final int disXp;
  final int recXp;
  final int currentStreak;
  final int longestStreak;

  /// Days where every scheduled quest was cleared. Added in schema v2.
  final int perfectDays;
  final int? lastActiveDay;
  final int acknowledgedLevel;
  final String acknowledgedRank;
  const PlayerStateRow({
    required this.id,
    required this.hunterName,
    required this.totalXp,
    required this.strXp,
    required this.staXp,
    required this.disXp,
    required this.recXp,
    required this.currentStreak,
    required this.longestStreak,
    required this.perfectDays,
    this.lastActiveDay,
    required this.acknowledgedLevel,
    required this.acknowledgedRank,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['hunter_name'] = Variable<String>(hunterName);
    map['total_xp'] = Variable<int>(totalXp);
    map['str_xp'] = Variable<int>(strXp);
    map['sta_xp'] = Variable<int>(staXp);
    map['dis_xp'] = Variable<int>(disXp);
    map['rec_xp'] = Variable<int>(recXp);
    map['current_streak'] = Variable<int>(currentStreak);
    map['longest_streak'] = Variable<int>(longestStreak);
    map['perfect_days'] = Variable<int>(perfectDays);
    if (!nullToAbsent || lastActiveDay != null) {
      map['last_active_day'] = Variable<int>(lastActiveDay);
    }
    map['acknowledged_level'] = Variable<int>(acknowledgedLevel);
    map['acknowledged_rank'] = Variable<String>(acknowledgedRank);
    return map;
  }

  PlayerStatesCompanion toCompanion(bool nullToAbsent) {
    return PlayerStatesCompanion(
      id: Value(id),
      hunterName: Value(hunterName),
      totalXp: Value(totalXp),
      strXp: Value(strXp),
      staXp: Value(staXp),
      disXp: Value(disXp),
      recXp: Value(recXp),
      currentStreak: Value(currentStreak),
      longestStreak: Value(longestStreak),
      perfectDays: Value(perfectDays),
      lastActiveDay: lastActiveDay == null && nullToAbsent
          ? const Value.absent()
          : Value(lastActiveDay),
      acknowledgedLevel: Value(acknowledgedLevel),
      acknowledgedRank: Value(acknowledgedRank),
    );
  }

  factory PlayerStateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlayerStateRow(
      id: serializer.fromJson<int>(json['id']),
      hunterName: serializer.fromJson<String>(json['hunterName']),
      totalXp: serializer.fromJson<int>(json['totalXp']),
      strXp: serializer.fromJson<int>(json['strXp']),
      staXp: serializer.fromJson<int>(json['staXp']),
      disXp: serializer.fromJson<int>(json['disXp']),
      recXp: serializer.fromJson<int>(json['recXp']),
      currentStreak: serializer.fromJson<int>(json['currentStreak']),
      longestStreak: serializer.fromJson<int>(json['longestStreak']),
      perfectDays: serializer.fromJson<int>(json['perfectDays']),
      lastActiveDay: serializer.fromJson<int?>(json['lastActiveDay']),
      acknowledgedLevel: serializer.fromJson<int>(json['acknowledgedLevel']),
      acknowledgedRank: serializer.fromJson<String>(json['acknowledgedRank']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'hunterName': serializer.toJson<String>(hunterName),
      'totalXp': serializer.toJson<int>(totalXp),
      'strXp': serializer.toJson<int>(strXp),
      'staXp': serializer.toJson<int>(staXp),
      'disXp': serializer.toJson<int>(disXp),
      'recXp': serializer.toJson<int>(recXp),
      'currentStreak': serializer.toJson<int>(currentStreak),
      'longestStreak': serializer.toJson<int>(longestStreak),
      'perfectDays': serializer.toJson<int>(perfectDays),
      'lastActiveDay': serializer.toJson<int?>(lastActiveDay),
      'acknowledgedLevel': serializer.toJson<int>(acknowledgedLevel),
      'acknowledgedRank': serializer.toJson<String>(acknowledgedRank),
    };
  }

  PlayerStateRow copyWith({
    int? id,
    String? hunterName,
    int? totalXp,
    int? strXp,
    int? staXp,
    int? disXp,
    int? recXp,
    int? currentStreak,
    int? longestStreak,
    int? perfectDays,
    Value<int?> lastActiveDay = const Value.absent(),
    int? acknowledgedLevel,
    String? acknowledgedRank,
  }) => PlayerStateRow(
    id: id ?? this.id,
    hunterName: hunterName ?? this.hunterName,
    totalXp: totalXp ?? this.totalXp,
    strXp: strXp ?? this.strXp,
    staXp: staXp ?? this.staXp,
    disXp: disXp ?? this.disXp,
    recXp: recXp ?? this.recXp,
    currentStreak: currentStreak ?? this.currentStreak,
    longestStreak: longestStreak ?? this.longestStreak,
    perfectDays: perfectDays ?? this.perfectDays,
    lastActiveDay: lastActiveDay.present
        ? lastActiveDay.value
        : this.lastActiveDay,
    acknowledgedLevel: acknowledgedLevel ?? this.acknowledgedLevel,
    acknowledgedRank: acknowledgedRank ?? this.acknowledgedRank,
  );
  PlayerStateRow copyWithCompanion(PlayerStatesCompanion data) {
    return PlayerStateRow(
      id: data.id.present ? data.id.value : this.id,
      hunterName: data.hunterName.present
          ? data.hunterName.value
          : this.hunterName,
      totalXp: data.totalXp.present ? data.totalXp.value : this.totalXp,
      strXp: data.strXp.present ? data.strXp.value : this.strXp,
      staXp: data.staXp.present ? data.staXp.value : this.staXp,
      disXp: data.disXp.present ? data.disXp.value : this.disXp,
      recXp: data.recXp.present ? data.recXp.value : this.recXp,
      currentStreak: data.currentStreak.present
          ? data.currentStreak.value
          : this.currentStreak,
      longestStreak: data.longestStreak.present
          ? data.longestStreak.value
          : this.longestStreak,
      perfectDays: data.perfectDays.present
          ? data.perfectDays.value
          : this.perfectDays,
      lastActiveDay: data.lastActiveDay.present
          ? data.lastActiveDay.value
          : this.lastActiveDay,
      acknowledgedLevel: data.acknowledgedLevel.present
          ? data.acknowledgedLevel.value
          : this.acknowledgedLevel,
      acknowledgedRank: data.acknowledgedRank.present
          ? data.acknowledgedRank.value
          : this.acknowledgedRank,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlayerStateRow(')
          ..write('id: $id, ')
          ..write('hunterName: $hunterName, ')
          ..write('totalXp: $totalXp, ')
          ..write('strXp: $strXp, ')
          ..write('staXp: $staXp, ')
          ..write('disXp: $disXp, ')
          ..write('recXp: $recXp, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('longestStreak: $longestStreak, ')
          ..write('perfectDays: $perfectDays, ')
          ..write('lastActiveDay: $lastActiveDay, ')
          ..write('acknowledgedLevel: $acknowledgedLevel, ')
          ..write('acknowledgedRank: $acknowledgedRank')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    hunterName,
    totalXp,
    strXp,
    staXp,
    disXp,
    recXp,
    currentStreak,
    longestStreak,
    perfectDays,
    lastActiveDay,
    acknowledgedLevel,
    acknowledgedRank,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlayerStateRow &&
          other.id == this.id &&
          other.hunterName == this.hunterName &&
          other.totalXp == this.totalXp &&
          other.strXp == this.strXp &&
          other.staXp == this.staXp &&
          other.disXp == this.disXp &&
          other.recXp == this.recXp &&
          other.currentStreak == this.currentStreak &&
          other.longestStreak == this.longestStreak &&
          other.perfectDays == this.perfectDays &&
          other.lastActiveDay == this.lastActiveDay &&
          other.acknowledgedLevel == this.acknowledgedLevel &&
          other.acknowledgedRank == this.acknowledgedRank);
}

class PlayerStatesCompanion extends UpdateCompanion<PlayerStateRow> {
  final Value<int> id;
  final Value<String> hunterName;
  final Value<int> totalXp;
  final Value<int> strXp;
  final Value<int> staXp;
  final Value<int> disXp;
  final Value<int> recXp;
  final Value<int> currentStreak;
  final Value<int> longestStreak;
  final Value<int> perfectDays;
  final Value<int?> lastActiveDay;
  final Value<int> acknowledgedLevel;
  final Value<String> acknowledgedRank;
  const PlayerStatesCompanion({
    this.id = const Value.absent(),
    this.hunterName = const Value.absent(),
    this.totalXp = const Value.absent(),
    this.strXp = const Value.absent(),
    this.staXp = const Value.absent(),
    this.disXp = const Value.absent(),
    this.recXp = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.longestStreak = const Value.absent(),
    this.perfectDays = const Value.absent(),
    this.lastActiveDay = const Value.absent(),
    this.acknowledgedLevel = const Value.absent(),
    this.acknowledgedRank = const Value.absent(),
  });
  PlayerStatesCompanion.insert({
    this.id = const Value.absent(),
    this.hunterName = const Value.absent(),
    this.totalXp = const Value.absent(),
    this.strXp = const Value.absent(),
    this.staXp = const Value.absent(),
    this.disXp = const Value.absent(),
    this.recXp = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.longestStreak = const Value.absent(),
    this.perfectDays = const Value.absent(),
    this.lastActiveDay = const Value.absent(),
    this.acknowledgedLevel = const Value.absent(),
    this.acknowledgedRank = const Value.absent(),
  });
  static Insertable<PlayerStateRow> custom({
    Expression<int>? id,
    Expression<String>? hunterName,
    Expression<int>? totalXp,
    Expression<int>? strXp,
    Expression<int>? staXp,
    Expression<int>? disXp,
    Expression<int>? recXp,
    Expression<int>? currentStreak,
    Expression<int>? longestStreak,
    Expression<int>? perfectDays,
    Expression<int>? lastActiveDay,
    Expression<int>? acknowledgedLevel,
    Expression<String>? acknowledgedRank,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (hunterName != null) 'hunter_name': hunterName,
      if (totalXp != null) 'total_xp': totalXp,
      if (strXp != null) 'str_xp': strXp,
      if (staXp != null) 'sta_xp': staXp,
      if (disXp != null) 'dis_xp': disXp,
      if (recXp != null) 'rec_xp': recXp,
      if (currentStreak != null) 'current_streak': currentStreak,
      if (longestStreak != null) 'longest_streak': longestStreak,
      if (perfectDays != null) 'perfect_days': perfectDays,
      if (lastActiveDay != null) 'last_active_day': lastActiveDay,
      if (acknowledgedLevel != null) 'acknowledged_level': acknowledgedLevel,
      if (acknowledgedRank != null) 'acknowledged_rank': acknowledgedRank,
    });
  }

  PlayerStatesCompanion copyWith({
    Value<int>? id,
    Value<String>? hunterName,
    Value<int>? totalXp,
    Value<int>? strXp,
    Value<int>? staXp,
    Value<int>? disXp,
    Value<int>? recXp,
    Value<int>? currentStreak,
    Value<int>? longestStreak,
    Value<int>? perfectDays,
    Value<int?>? lastActiveDay,
    Value<int>? acknowledgedLevel,
    Value<String>? acknowledgedRank,
  }) {
    return PlayerStatesCompanion(
      id: id ?? this.id,
      hunterName: hunterName ?? this.hunterName,
      totalXp: totalXp ?? this.totalXp,
      strXp: strXp ?? this.strXp,
      staXp: staXp ?? this.staXp,
      disXp: disXp ?? this.disXp,
      recXp: recXp ?? this.recXp,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      perfectDays: perfectDays ?? this.perfectDays,
      lastActiveDay: lastActiveDay ?? this.lastActiveDay,
      acknowledgedLevel: acknowledgedLevel ?? this.acknowledgedLevel,
      acknowledgedRank: acknowledgedRank ?? this.acknowledgedRank,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (hunterName.present) {
      map['hunter_name'] = Variable<String>(hunterName.value);
    }
    if (totalXp.present) {
      map['total_xp'] = Variable<int>(totalXp.value);
    }
    if (strXp.present) {
      map['str_xp'] = Variable<int>(strXp.value);
    }
    if (staXp.present) {
      map['sta_xp'] = Variable<int>(staXp.value);
    }
    if (disXp.present) {
      map['dis_xp'] = Variable<int>(disXp.value);
    }
    if (recXp.present) {
      map['rec_xp'] = Variable<int>(recXp.value);
    }
    if (currentStreak.present) {
      map['current_streak'] = Variable<int>(currentStreak.value);
    }
    if (longestStreak.present) {
      map['longest_streak'] = Variable<int>(longestStreak.value);
    }
    if (perfectDays.present) {
      map['perfect_days'] = Variable<int>(perfectDays.value);
    }
    if (lastActiveDay.present) {
      map['last_active_day'] = Variable<int>(lastActiveDay.value);
    }
    if (acknowledgedLevel.present) {
      map['acknowledged_level'] = Variable<int>(acknowledgedLevel.value);
    }
    if (acknowledgedRank.present) {
      map['acknowledged_rank'] = Variable<String>(acknowledgedRank.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayerStatesCompanion(')
          ..write('id: $id, ')
          ..write('hunterName: $hunterName, ')
          ..write('totalXp: $totalXp, ')
          ..write('strXp: $strXp, ')
          ..write('staXp: $staXp, ')
          ..write('disXp: $disXp, ')
          ..write('recXp: $recXp, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('longestStreak: $longestStreak, ')
          ..write('perfectDays: $perfectDays, ')
          ..write('lastActiveDay: $lastActiveDay, ')
          ..write('acknowledgedLevel: $acknowledgedLevel, ')
          ..write('acknowledgedRank: $acknowledgedRank')
          ..write(')'))
        .toString();
  }
}

class $ActivityLogEntriesTable extends ActivityLogEntries
    with TableInfo<$ActivityLogEntriesTable, ActivityLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityLogEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ActivityKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ActivityKind>($ActivityLogEntriesTable.$converterkind);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detailMeta = const VerificationMeta('detail');
  @override
  late final GeneratedColumn<String> detail = GeneratedColumn<String>(
    'detail',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _xpDeltaMeta = const VerificationMeta(
    'xpDelta',
  );
  @override
  late final GeneratedColumn<int> xpDelta = GeneratedColumn<int>(
    'xp_delta',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, at, kind, title, detail, xpDelta];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_log_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityLogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('detail')) {
      context.handle(
        _detailMeta,
        detail.isAcceptableOrUnknown(data['detail']!, _detailMeta),
      );
    }
    if (data.containsKey('xp_delta')) {
      context.handle(
        _xpDeltaMeta,
        xpDelta.isAcceptableOrUnknown(data['xp_delta']!, _xpDeltaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivityLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityLogRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
      kind: $ActivityLogEntriesTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      detail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detail'],
      ),
      xpDelta: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}xp_delta'],
      ),
    );
  }

  @override
  $ActivityLogEntriesTable createAlias(String alias) {
    return $ActivityLogEntriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ActivityKind, String, String> $converterkind =
      const EnumNameConverter<ActivityKind>(ActivityKind.values);
}

class ActivityLogRow extends DataClass implements Insertable<ActivityLogRow> {
  final int id;
  final DateTime at;
  final ActivityKind kind;
  final String title;
  final String? detail;
  final int? xpDelta;
  const ActivityLogRow({
    required this.id,
    required this.at,
    required this.kind,
    required this.title,
    this.detail,
    this.xpDelta,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['at'] = Variable<DateTime>(at);
    {
      map['kind'] = Variable<String>(
        $ActivityLogEntriesTable.$converterkind.toSql(kind),
      );
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || detail != null) {
      map['detail'] = Variable<String>(detail);
    }
    if (!nullToAbsent || xpDelta != null) {
      map['xp_delta'] = Variable<int>(xpDelta);
    }
    return map;
  }

  ActivityLogEntriesCompanion toCompanion(bool nullToAbsent) {
    return ActivityLogEntriesCompanion(
      id: Value(id),
      at: Value(at),
      kind: Value(kind),
      title: Value(title),
      detail: detail == null && nullToAbsent
          ? const Value.absent()
          : Value(detail),
      xpDelta: xpDelta == null && nullToAbsent
          ? const Value.absent()
          : Value(xpDelta),
    );
  }

  factory ActivityLogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityLogRow(
      id: serializer.fromJson<int>(json['id']),
      at: serializer.fromJson<DateTime>(json['at']),
      kind: $ActivityLogEntriesTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      title: serializer.fromJson<String>(json['title']),
      detail: serializer.fromJson<String?>(json['detail']),
      xpDelta: serializer.fromJson<int?>(json['xpDelta']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'at': serializer.toJson<DateTime>(at),
      'kind': serializer.toJson<String>(
        $ActivityLogEntriesTable.$converterkind.toJson(kind),
      ),
      'title': serializer.toJson<String>(title),
      'detail': serializer.toJson<String?>(detail),
      'xpDelta': serializer.toJson<int?>(xpDelta),
    };
  }

  ActivityLogRow copyWith({
    int? id,
    DateTime? at,
    ActivityKind? kind,
    String? title,
    Value<String?> detail = const Value.absent(),
    Value<int?> xpDelta = const Value.absent(),
  }) => ActivityLogRow(
    id: id ?? this.id,
    at: at ?? this.at,
    kind: kind ?? this.kind,
    title: title ?? this.title,
    detail: detail.present ? detail.value : this.detail,
    xpDelta: xpDelta.present ? xpDelta.value : this.xpDelta,
  );
  ActivityLogRow copyWithCompanion(ActivityLogEntriesCompanion data) {
    return ActivityLogRow(
      id: data.id.present ? data.id.value : this.id,
      at: data.at.present ? data.at.value : this.at,
      kind: data.kind.present ? data.kind.value : this.kind,
      title: data.title.present ? data.title.value : this.title,
      detail: data.detail.present ? data.detail.value : this.detail,
      xpDelta: data.xpDelta.present ? data.xpDelta.value : this.xpDelta,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityLogRow(')
          ..write('id: $id, ')
          ..write('at: $at, ')
          ..write('kind: $kind, ')
          ..write('title: $title, ')
          ..write('detail: $detail, ')
          ..write('xpDelta: $xpDelta')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, at, kind, title, detail, xpDelta);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityLogRow &&
          other.id == this.id &&
          other.at == this.at &&
          other.kind == this.kind &&
          other.title == this.title &&
          other.detail == this.detail &&
          other.xpDelta == this.xpDelta);
}

class ActivityLogEntriesCompanion extends UpdateCompanion<ActivityLogRow> {
  final Value<int> id;
  final Value<DateTime> at;
  final Value<ActivityKind> kind;
  final Value<String> title;
  final Value<String?> detail;
  final Value<int?> xpDelta;
  const ActivityLogEntriesCompanion({
    this.id = const Value.absent(),
    this.at = const Value.absent(),
    this.kind = const Value.absent(),
    this.title = const Value.absent(),
    this.detail = const Value.absent(),
    this.xpDelta = const Value.absent(),
  });
  ActivityLogEntriesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime at,
    required ActivityKind kind,
    required String title,
    this.detail = const Value.absent(),
    this.xpDelta = const Value.absent(),
  }) : at = Value(at),
       kind = Value(kind),
       title = Value(title);
  static Insertable<ActivityLogRow> custom({
    Expression<int>? id,
    Expression<DateTime>? at,
    Expression<String>? kind,
    Expression<String>? title,
    Expression<String>? detail,
    Expression<int>? xpDelta,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (at != null) 'at': at,
      if (kind != null) 'kind': kind,
      if (title != null) 'title': title,
      if (detail != null) 'detail': detail,
      if (xpDelta != null) 'xp_delta': xpDelta,
    });
  }

  ActivityLogEntriesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? at,
    Value<ActivityKind>? kind,
    Value<String>? title,
    Value<String?>? detail,
    Value<int?>? xpDelta,
  }) {
    return ActivityLogEntriesCompanion(
      id: id ?? this.id,
      at: at ?? this.at,
      kind: kind ?? this.kind,
      title: title ?? this.title,
      detail: detail ?? this.detail,
      xpDelta: xpDelta ?? this.xpDelta,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $ActivityLogEntriesTable.$converterkind.toSql(kind.value),
      );
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (detail.present) {
      map['detail'] = Variable<String>(detail.value);
    }
    if (xpDelta.present) {
      map['xp_delta'] = Variable<int>(xpDelta.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityLogEntriesCompanion(')
          ..write('id: $id, ')
          ..write('at: $at, ')
          ..write('kind: $kind, ')
          ..write('title: $title, ')
          ..write('detail: $detail, ')
          ..write('xpDelta: $xpDelta')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TaskTemplatesTable taskTemplates = $TaskTemplatesTable(this);
  late final $DailyQuestsTable dailyQuests = $DailyQuestsTable(this);
  late final $DayRollupsTable dayRollups = $DayRollupsTable(this);
  late final $PlayerStatesTable playerStates = $PlayerStatesTable(this);
  late final $ActivityLogEntriesTable activityLogEntries =
      $ActivityLogEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    taskTemplates,
    dailyQuests,
    dayRollups,
    playerStates,
    activityLogEntries,
  ];
}

typedef $$TaskTemplatesTableCreateCompanionBuilder =
    TaskTemplatesCompanion Function({
      required String id,
      required String title,
      required TaskCategory category,
      required StatType stat,
      required ScheduleType schedule,
      Value<List<int>> daysOfWeek,
      required int xp,
      Value<int?> scheduledMinutes,
      Value<int> graceMinutes,
      Value<bool> isActive,
      Value<int> sortOrder,
      required DateTime createdAt,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });
typedef $$TaskTemplatesTableUpdateCompanionBuilder =
    TaskTemplatesCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<TaskCategory> category,
      Value<StatType> stat,
      Value<ScheduleType> schedule,
      Value<List<int>> daysOfWeek,
      Value<int> xp,
      Value<int?> scheduledMinutes,
      Value<int> graceMinutes,
      Value<bool> isActive,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });

final class $$TaskTemplatesTableReferences
    extends
        BaseReferences<_$AppDatabase, $TaskTemplatesTable, TaskTemplateRow> {
  $$TaskTemplatesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$DailyQuestsTable, List<DailyQuestRow>>
  _dailyQuestsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.dailyQuests,
    aliasName: 'task_templates__id__daily_quests__template_id',
  );

  $$DailyQuestsTableProcessedTableManager get dailyQuestsRefs {
    final manager = $$DailyQuestsTableTableManager(
      $_db,
      $_db.dailyQuests,
    ).filter((f) => f.templateId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_dailyQuestsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TaskTemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $TaskTemplatesTable> {
  $$TaskTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TaskCategory, TaskCategory, String>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<StatType, StatType, String> get stat =>
      $composableBuilder(
        column: $table.stat,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<ScheduleType, ScheduleType, String>
  get schedule => $composableBuilder(
    column: $table.schedule,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<int>, List<int>, String> get daysOfWeek =>
      $composableBuilder(
        column: $table.daysOfWeek,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get xp => $composableBuilder(
    column: $table.xp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scheduledMinutes => $composableBuilder(
    column: $table.scheduledMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get graceMinutes => $composableBuilder(
    column: $table.graceMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> dailyQuestsRefs(
    Expression<bool> Function($$DailyQuestsTableFilterComposer f) f,
  ) {
    final $$DailyQuestsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dailyQuests,
      getReferencedColumn: (t) => t.templateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyQuestsTableFilterComposer(
            $db: $db,
            $table: $db.dailyQuests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TaskTemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskTemplatesTable> {
  $$TaskTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stat => $composableBuilder(
    column: $table.stat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get schedule => $composableBuilder(
    column: $table.schedule,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get daysOfWeek => $composableBuilder(
    column: $table.daysOfWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get xp => $composableBuilder(
    column: $table.xp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scheduledMinutes => $composableBuilder(
    column: $table.scheduledMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get graceMinutes => $composableBuilder(
    column: $table.graceMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TaskTemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskTemplatesTable> {
  $$TaskTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TaskCategory, String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumnWithTypeConverter<StatType, String> get stat =>
      $composableBuilder(column: $table.stat, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ScheduleType, String> get schedule =>
      $composableBuilder(column: $table.schedule, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<int>, String> get daysOfWeek =>
      $composableBuilder(
        column: $table.daysOfWeek,
        builder: (column) => column,
      );

  GeneratedColumn<int> get xp =>
      $composableBuilder(column: $table.xp, builder: (column) => column);

  GeneratedColumn<int> get scheduledMinutes => $composableBuilder(
    column: $table.scheduledMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get graceMinutes => $composableBuilder(
    column: $table.graceMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  Expression<T> dailyQuestsRefs<T extends Object>(
    Expression<T> Function($$DailyQuestsTableAnnotationComposer a) f,
  ) {
    final $$DailyQuestsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dailyQuests,
      getReferencedColumn: (t) => t.templateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyQuestsTableAnnotationComposer(
            $db: $db,
            $table: $db.dailyQuests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TaskTemplatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskTemplatesTable,
          TaskTemplateRow,
          $$TaskTemplatesTableFilterComposer,
          $$TaskTemplatesTableOrderingComposer,
          $$TaskTemplatesTableAnnotationComposer,
          $$TaskTemplatesTableCreateCompanionBuilder,
          $$TaskTemplatesTableUpdateCompanionBuilder,
          (TaskTemplateRow, $$TaskTemplatesTableReferences),
          TaskTemplateRow,
          PrefetchHooks Function({bool dailyQuestsRefs})
        > {
  $$TaskTemplatesTableTableManager(_$AppDatabase db, $TaskTemplatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskTemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<TaskCategory> category = const Value.absent(),
                Value<StatType> stat = const Value.absent(),
                Value<ScheduleType> schedule = const Value.absent(),
                Value<List<int>> daysOfWeek = const Value.absent(),
                Value<int> xp = const Value.absent(),
                Value<int?> scheduledMinutes = const Value.absent(),
                Value<int> graceMinutes = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskTemplatesCompanion(
                id: id,
                title: title,
                category: category,
                stat: stat,
                schedule: schedule,
                daysOfWeek: daysOfWeek,
                xp: xp,
                scheduledMinutes: scheduledMinutes,
                graceMinutes: graceMinutes,
                isActive: isActive,
                sortOrder: sortOrder,
                createdAt: createdAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required TaskCategory category,
                required StatType stat,
                required ScheduleType schedule,
                Value<List<int>> daysOfWeek = const Value.absent(),
                required int xp,
                Value<int?> scheduledMinutes = const Value.absent(),
                Value<int> graceMinutes = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskTemplatesCompanion.insert(
                id: id,
                title: title,
                category: category,
                stat: stat,
                schedule: schedule,
                daysOfWeek: daysOfWeek,
                xp: xp,
                scheduledMinutes: scheduledMinutes,
                graceMinutes: graceMinutes,
                isActive: isActive,
                sortOrder: sortOrder,
                createdAt: createdAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TaskTemplatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({dailyQuestsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (dailyQuestsRefs) db.dailyQuests],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (dailyQuestsRefs)
                    await $_getPrefetchedData<
                      TaskTemplateRow,
                      $TaskTemplatesTable,
                      DailyQuestRow
                    >(
                      currentTable: table,
                      referencedTable: $$TaskTemplatesTableReferences
                          ._dailyQuestsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TaskTemplatesTableReferences(
                            db,
                            table,
                            p0,
                          ).dailyQuestsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.templateId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TaskTemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskTemplatesTable,
      TaskTemplateRow,
      $$TaskTemplatesTableFilterComposer,
      $$TaskTemplatesTableOrderingComposer,
      $$TaskTemplatesTableAnnotationComposer,
      $$TaskTemplatesTableCreateCompanionBuilder,
      $$TaskTemplatesTableUpdateCompanionBuilder,
      (TaskTemplateRow, $$TaskTemplatesTableReferences),
      TaskTemplateRow,
      PrefetchHooks Function({bool dailyQuestsRefs})
    >;
typedef $$DailyQuestsTableCreateCompanionBuilder =
    DailyQuestsCompanion Function({
      Value<int> id,
      required String templateId,
      required int day,
      Value<QuestStatus> status,
      Value<DateTime?> completedAt,
      required int xpAwarded,
      required StatType stat,
      Value<int?> scheduledMinutes,
      Value<int> graceMinutes,
    });
typedef $$DailyQuestsTableUpdateCompanionBuilder =
    DailyQuestsCompanion Function({
      Value<int> id,
      Value<String> templateId,
      Value<int> day,
      Value<QuestStatus> status,
      Value<DateTime?> completedAt,
      Value<int> xpAwarded,
      Value<StatType> stat,
      Value<int?> scheduledMinutes,
      Value<int> graceMinutes,
    });

final class $$DailyQuestsTableReferences
    extends BaseReferences<_$AppDatabase, $DailyQuestsTable, DailyQuestRow> {
  $$DailyQuestsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TaskTemplatesTable _templateIdTable(_$AppDatabase db) => db
      .taskTemplates
      .createAlias('daily_quests__template_id__task_templates__id');

  $$TaskTemplatesTableProcessedTableManager get templateId {
    final $_column = $_itemColumn<String>('template_id')!;

    final manager = $$TaskTemplatesTableTableManager(
      $_db,
      $_db.taskTemplates,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_templateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DailyQuestsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyQuestsTable> {
  $$DailyQuestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<QuestStatus, QuestStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get xpAwarded => $composableBuilder(
    column: $table.xpAwarded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<StatType, StatType, String> get stat =>
      $composableBuilder(
        column: $table.stat,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get scheduledMinutes => $composableBuilder(
    column: $table.scheduledMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get graceMinutes => $composableBuilder(
    column: $table.graceMinutes,
    builder: (column) => ColumnFilters(column),
  );

  $$TaskTemplatesTableFilterComposer get templateId {
    final $$TaskTemplatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.taskTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskTemplatesTableFilterComposer(
            $db: $db,
            $table: $db.taskTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyQuestsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyQuestsTable> {
  $$DailyQuestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get xpAwarded => $composableBuilder(
    column: $table.xpAwarded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stat => $composableBuilder(
    column: $table.stat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scheduledMinutes => $composableBuilder(
    column: $table.scheduledMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get graceMinutes => $composableBuilder(
    column: $table.graceMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  $$TaskTemplatesTableOrderingComposer get templateId {
    final $$TaskTemplatesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.taskTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskTemplatesTableOrderingComposer(
            $db: $db,
            $table: $db.taskTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyQuestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyQuestsTable> {
  $$DailyQuestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumnWithTypeConverter<QuestStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get xpAwarded =>
      $composableBuilder(column: $table.xpAwarded, builder: (column) => column);

  GeneratedColumnWithTypeConverter<StatType, String> get stat =>
      $composableBuilder(column: $table.stat, builder: (column) => column);

  GeneratedColumn<int> get scheduledMinutes => $composableBuilder(
    column: $table.scheduledMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get graceMinutes => $composableBuilder(
    column: $table.graceMinutes,
    builder: (column) => column,
  );

  $$TaskTemplatesTableAnnotationComposer get templateId {
    final $$TaskTemplatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.taskTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskTemplatesTableAnnotationComposer(
            $db: $db,
            $table: $db.taskTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyQuestsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyQuestsTable,
          DailyQuestRow,
          $$DailyQuestsTableFilterComposer,
          $$DailyQuestsTableOrderingComposer,
          $$DailyQuestsTableAnnotationComposer,
          $$DailyQuestsTableCreateCompanionBuilder,
          $$DailyQuestsTableUpdateCompanionBuilder,
          (DailyQuestRow, $$DailyQuestsTableReferences),
          DailyQuestRow,
          PrefetchHooks Function({bool templateId})
        > {
  $$DailyQuestsTableTableManager(_$AppDatabase db, $DailyQuestsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyQuestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyQuestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyQuestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> templateId = const Value.absent(),
                Value<int> day = const Value.absent(),
                Value<QuestStatus> status = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> xpAwarded = const Value.absent(),
                Value<StatType> stat = const Value.absent(),
                Value<int?> scheduledMinutes = const Value.absent(),
                Value<int> graceMinutes = const Value.absent(),
              }) => DailyQuestsCompanion(
                id: id,
                templateId: templateId,
                day: day,
                status: status,
                completedAt: completedAt,
                xpAwarded: xpAwarded,
                stat: stat,
                scheduledMinutes: scheduledMinutes,
                graceMinutes: graceMinutes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String templateId,
                required int day,
                Value<QuestStatus> status = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                required int xpAwarded,
                required StatType stat,
                Value<int?> scheduledMinutes = const Value.absent(),
                Value<int> graceMinutes = const Value.absent(),
              }) => DailyQuestsCompanion.insert(
                id: id,
                templateId: templateId,
                day: day,
                status: status,
                completedAt: completedAt,
                xpAwarded: xpAwarded,
                stat: stat,
                scheduledMinutes: scheduledMinutes,
                graceMinutes: graceMinutes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DailyQuestsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({templateId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (templateId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.templateId,
                        referencedTable: $$DailyQuestsTableReferences
                            ._templateIdTable(db),
                        referencedColumn: $$DailyQuestsTableReferences
                            ._templateIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DailyQuestsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyQuestsTable,
      DailyQuestRow,
      $$DailyQuestsTableFilterComposer,
      $$DailyQuestsTableOrderingComposer,
      $$DailyQuestsTableAnnotationComposer,
      $$DailyQuestsTableCreateCompanionBuilder,
      $$DailyQuestsTableUpdateCompanionBuilder,
      (DailyQuestRow, $$DailyQuestsTableReferences),
      DailyQuestRow,
      PrefetchHooks Function({bool templateId})
    >;
typedef $$DayRollupsTableCreateCompanionBuilder = DayRollupsCompanion Function({
  Value<int> day,
  Value<int> xpEarned,
  Value<int> xpAvailable,
  Value<int> questsCleared,
  Value<int> questsMissed,
  Value<int> questsTotal,
  Value<bool> isPerfect,
  Value<int> strXp,
  Value<int> staXp,
  Value<int> disXp,
  Value<int> recXp,
});
typedef $$DayRollupsTableUpdateCompanionBuilder = DayRollupsCompanion Function({
  Value<int> day,
  Value<int> xpEarned,
  Value<int> xpAvailable,
  Value<int> questsCleared,
  Value<int> questsMissed,
  Value<int> questsTotal,
  Value<bool> isPerfect,
  Value<int> strXp,
  Value<int> staXp,
  Value<int> disXp,
  Value<int> recXp,
});

class $$DayRollupsTableFilterComposer
    extends Composer<_$AppDatabase, $DayRollupsTable> {
  $$DayRollupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get xpEarned => $composableBuilder(
    column: $table.xpEarned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get xpAvailable => $composableBuilder(
    column: $table.xpAvailable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get questsCleared => $composableBuilder(
    column: $table.questsCleared,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get questsMissed => $composableBuilder(
    column: $table.questsMissed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get questsTotal => $composableBuilder(
    column: $table.questsTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPerfect => $composableBuilder(
    column: $table.isPerfect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get strXp => $composableBuilder(
    column: $table.strXp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get staXp => $composableBuilder(
    column: $table.staXp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get disXp => $composableBuilder(
    column: $table.disXp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recXp => $composableBuilder(
    column: $table.recXp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DayRollupsTableOrderingComposer
    extends Composer<_$AppDatabase, $DayRollupsTable> {
  $$DayRollupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get xpEarned => $composableBuilder(
    column: $table.xpEarned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get xpAvailable => $composableBuilder(
    column: $table.xpAvailable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get questsCleared => $composableBuilder(
    column: $table.questsCleared,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get questsMissed => $composableBuilder(
    column: $table.questsMissed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get questsTotal => $composableBuilder(
    column: $table.questsTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPerfect => $composableBuilder(
    column: $table.isPerfect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get strXp => $composableBuilder(
    column: $table.strXp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get staXp => $composableBuilder(
    column: $table.staXp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get disXp => $composableBuilder(
    column: $table.disXp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recXp => $composableBuilder(
    column: $table.recXp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DayRollupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DayRollupsTable> {
  $$DayRollupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<int> get xpEarned =>
      $composableBuilder(column: $table.xpEarned, builder: (column) => column);

  GeneratedColumn<int> get xpAvailable => $composableBuilder(
    column: $table.xpAvailable,
    builder: (column) => column,
  );

  GeneratedColumn<int> get questsCleared => $composableBuilder(
    column: $table.questsCleared,
    builder: (column) => column,
  );

  GeneratedColumn<int> get questsMissed => $composableBuilder(
    column: $table.questsMissed,
    builder: (column) => column,
  );

  GeneratedColumn<int> get questsTotal => $composableBuilder(
    column: $table.questsTotal,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPerfect =>
      $composableBuilder(column: $table.isPerfect, builder: (column) => column);

  GeneratedColumn<int> get strXp =>
      $composableBuilder(column: $table.strXp, builder: (column) => column);

  GeneratedColumn<int> get staXp =>
      $composableBuilder(column: $table.staXp, builder: (column) => column);

  GeneratedColumn<int> get disXp =>
      $composableBuilder(column: $table.disXp, builder: (column) => column);

  GeneratedColumn<int> get recXp =>
      $composableBuilder(column: $table.recXp, builder: (column) => column);
}

class $$DayRollupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DayRollupsTable,
          DayRollupRow,
          $$DayRollupsTableFilterComposer,
          $$DayRollupsTableOrderingComposer,
          $$DayRollupsTableAnnotationComposer,
          $$DayRollupsTableCreateCompanionBuilder,
          $$DayRollupsTableUpdateCompanionBuilder,
          (
            DayRollupRow,
            BaseReferences<_$AppDatabase, $DayRollupsTable, DayRollupRow>,
          ),
          DayRollupRow,
          PrefetchHooks Function()
        > {
  $$DayRollupsTableTableManager(_$AppDatabase db, $DayRollupsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DayRollupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DayRollupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DayRollupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> day = const Value.absent(),
                Value<int> xpEarned = const Value.absent(),
                Value<int> xpAvailable = const Value.absent(),
                Value<int> questsCleared = const Value.absent(),
                Value<int> questsMissed = const Value.absent(),
                Value<int> questsTotal = const Value.absent(),
                Value<bool> isPerfect = const Value.absent(),
                Value<int> strXp = const Value.absent(),
                Value<int> staXp = const Value.absent(),
                Value<int> disXp = const Value.absent(),
                Value<int> recXp = const Value.absent(),
              }) => DayRollupsCompanion(
                day: day,
                xpEarned: xpEarned,
                xpAvailable: xpAvailable,
                questsCleared: questsCleared,
                questsMissed: questsMissed,
                questsTotal: questsTotal,
                isPerfect: isPerfect,
                strXp: strXp,
                staXp: staXp,
                disXp: disXp,
                recXp: recXp,
              ),
          createCompanionCallback:
              ({
                Value<int> day = const Value.absent(),
                Value<int> xpEarned = const Value.absent(),
                Value<int> xpAvailable = const Value.absent(),
                Value<int> questsCleared = const Value.absent(),
                Value<int> questsMissed = const Value.absent(),
                Value<int> questsTotal = const Value.absent(),
                Value<bool> isPerfect = const Value.absent(),
                Value<int> strXp = const Value.absent(),
                Value<int> staXp = const Value.absent(),
                Value<int> disXp = const Value.absent(),
                Value<int> recXp = const Value.absent(),
              }) => DayRollupsCompanion.insert(
                day: day,
                xpEarned: xpEarned,
                xpAvailable: xpAvailable,
                questsCleared: questsCleared,
                questsMissed: questsMissed,
                questsTotal: questsTotal,
                isPerfect: isPerfect,
                strXp: strXp,
                staXp: staXp,
                disXp: disXp,
                recXp: recXp,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DayRollupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DayRollupsTable,
      DayRollupRow,
      $$DayRollupsTableFilterComposer,
      $$DayRollupsTableOrderingComposer,
      $$DayRollupsTableAnnotationComposer,
      $$DayRollupsTableCreateCompanionBuilder,
      $$DayRollupsTableUpdateCompanionBuilder,
      (
        DayRollupRow,
        BaseReferences<_$AppDatabase, $DayRollupsTable, DayRollupRow>,
      ),
      DayRollupRow,
      PrefetchHooks Function()
    >;
typedef $$PlayerStatesTableCreateCompanionBuilder =
    PlayerStatesCompanion Function({
      Value<int> id,
      Value<String> hunterName,
      Value<int> totalXp,
      Value<int> strXp,
      Value<int> staXp,
      Value<int> disXp,
      Value<int> recXp,
      Value<int> currentStreak,
      Value<int> longestStreak,
      Value<int> perfectDays,
      Value<int?> lastActiveDay,
      Value<int> acknowledgedLevel,
      Value<String> acknowledgedRank,
    });
typedef $$PlayerStatesTableUpdateCompanionBuilder =
    PlayerStatesCompanion Function({
      Value<int> id,
      Value<String> hunterName,
      Value<int> totalXp,
      Value<int> strXp,
      Value<int> staXp,
      Value<int> disXp,
      Value<int> recXp,
      Value<int> currentStreak,
      Value<int> longestStreak,
      Value<int> perfectDays,
      Value<int?> lastActiveDay,
      Value<int> acknowledgedLevel,
      Value<String> acknowledgedRank,
    });

class $$PlayerStatesTableFilterComposer
    extends Composer<_$AppDatabase, $PlayerStatesTable> {
  $$PlayerStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hunterName => $composableBuilder(
    column: $table.hunterName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalXp => $composableBuilder(
    column: $table.totalXp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get strXp => $composableBuilder(
    column: $table.strXp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get staXp => $composableBuilder(
    column: $table.staXp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get disXp => $composableBuilder(
    column: $table.disXp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recXp => $composableBuilder(
    column: $table.recXp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get longestStreak => $composableBuilder(
    column: $table.longestStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get perfectDays => $composableBuilder(
    column: $table.perfectDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastActiveDay => $composableBuilder(
    column: $table.lastActiveDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get acknowledgedLevel => $composableBuilder(
    column: $table.acknowledgedLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get acknowledgedRank => $composableBuilder(
    column: $table.acknowledgedRank,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlayerStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayerStatesTable> {
  $$PlayerStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hunterName => $composableBuilder(
    column: $table.hunterName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalXp => $composableBuilder(
    column: $table.totalXp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get strXp => $composableBuilder(
    column: $table.strXp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get staXp => $composableBuilder(
    column: $table.staXp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get disXp => $composableBuilder(
    column: $table.disXp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recXp => $composableBuilder(
    column: $table.recXp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get longestStreak => $composableBuilder(
    column: $table.longestStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get perfectDays => $composableBuilder(
    column: $table.perfectDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastActiveDay => $composableBuilder(
    column: $table.lastActiveDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get acknowledgedLevel => $composableBuilder(
    column: $table.acknowledgedLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get acknowledgedRank => $composableBuilder(
    column: $table.acknowledgedRank,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlayerStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayerStatesTable> {
  $$PlayerStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get hunterName => $composableBuilder(
    column: $table.hunterName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalXp =>
      $composableBuilder(column: $table.totalXp, builder: (column) => column);

  GeneratedColumn<int> get strXp =>
      $composableBuilder(column: $table.strXp, builder: (column) => column);

  GeneratedColumn<int> get staXp =>
      $composableBuilder(column: $table.staXp, builder: (column) => column);

  GeneratedColumn<int> get disXp =>
      $composableBuilder(column: $table.disXp, builder: (column) => column);

  GeneratedColumn<int> get recXp =>
      $composableBuilder(column: $table.recXp, builder: (column) => column);

  GeneratedColumn<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => column,
  );

  GeneratedColumn<int> get longestStreak => $composableBuilder(
    column: $table.longestStreak,
    builder: (column) => column,
  );

  GeneratedColumn<int> get perfectDays => $composableBuilder(
    column: $table.perfectDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastActiveDay => $composableBuilder(
    column: $table.lastActiveDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get acknowledgedLevel => $composableBuilder(
    column: $table.acknowledgedLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get acknowledgedRank => $composableBuilder(
    column: $table.acknowledgedRank,
    builder: (column) => column,
  );
}

class $$PlayerStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlayerStatesTable,
          PlayerStateRow,
          $$PlayerStatesTableFilterComposer,
          $$PlayerStatesTableOrderingComposer,
          $$PlayerStatesTableAnnotationComposer,
          $$PlayerStatesTableCreateCompanionBuilder,
          $$PlayerStatesTableUpdateCompanionBuilder,
          (
            PlayerStateRow,
            BaseReferences<_$AppDatabase, $PlayerStatesTable, PlayerStateRow>,
          ),
          PlayerStateRow,
          PrefetchHooks Function()
        > {
  $$PlayerStatesTableTableManager(_$AppDatabase db, $PlayerStatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayerStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayerStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayerStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> hunterName = const Value.absent(),
                Value<int> totalXp = const Value.absent(),
                Value<int> strXp = const Value.absent(),
                Value<int> staXp = const Value.absent(),
                Value<int> disXp = const Value.absent(),
                Value<int> recXp = const Value.absent(),
                Value<int> currentStreak = const Value.absent(),
                Value<int> longestStreak = const Value.absent(),
                Value<int> perfectDays = const Value.absent(),
                Value<int?> lastActiveDay = const Value.absent(),
                Value<int> acknowledgedLevel = const Value.absent(),
                Value<String> acknowledgedRank = const Value.absent(),
              }) => PlayerStatesCompanion(
                id: id,
                hunterName: hunterName,
                totalXp: totalXp,
                strXp: strXp,
                staXp: staXp,
                disXp: disXp,
                recXp: recXp,
                currentStreak: currentStreak,
                longestStreak: longestStreak,
                perfectDays: perfectDays,
                lastActiveDay: lastActiveDay,
                acknowledgedLevel: acknowledgedLevel,
                acknowledgedRank: acknowledgedRank,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> hunterName = const Value.absent(),
                Value<int> totalXp = const Value.absent(),
                Value<int> strXp = const Value.absent(),
                Value<int> staXp = const Value.absent(),
                Value<int> disXp = const Value.absent(),
                Value<int> recXp = const Value.absent(),
                Value<int> currentStreak = const Value.absent(),
                Value<int> longestStreak = const Value.absent(),
                Value<int> perfectDays = const Value.absent(),
                Value<int?> lastActiveDay = const Value.absent(),
                Value<int> acknowledgedLevel = const Value.absent(),
                Value<String> acknowledgedRank = const Value.absent(),
              }) => PlayerStatesCompanion.insert(
                id: id,
                hunterName: hunterName,
                totalXp: totalXp,
                strXp: strXp,
                staXp: staXp,
                disXp: disXp,
                recXp: recXp,
                currentStreak: currentStreak,
                longestStreak: longestStreak,
                perfectDays: perfectDays,
                lastActiveDay: lastActiveDay,
                acknowledgedLevel: acknowledgedLevel,
                acknowledgedRank: acknowledgedRank,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlayerStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlayerStatesTable,
      PlayerStateRow,
      $$PlayerStatesTableFilterComposer,
      $$PlayerStatesTableOrderingComposer,
      $$PlayerStatesTableAnnotationComposer,
      $$PlayerStatesTableCreateCompanionBuilder,
      $$PlayerStatesTableUpdateCompanionBuilder,
      (
        PlayerStateRow,
        BaseReferences<_$AppDatabase, $PlayerStatesTable, PlayerStateRow>,
      ),
      PlayerStateRow,
      PrefetchHooks Function()
    >;
typedef $$ActivityLogEntriesTableCreateCompanionBuilder =
    ActivityLogEntriesCompanion Function({
      Value<int> id,
      required DateTime at,
      required ActivityKind kind,
      required String title,
      Value<String?> detail,
      Value<int?> xpDelta,
    });
typedef $$ActivityLogEntriesTableUpdateCompanionBuilder =
    ActivityLogEntriesCompanion Function({
      Value<int> id,
      Value<DateTime> at,
      Value<ActivityKind> kind,
      Value<String> title,
      Value<String?> detail,
      Value<int?> xpDelta,
    });

class $$ActivityLogEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityLogEntriesTable> {
  $$ActivityLogEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ActivityKind, ActivityKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detail => $composableBuilder(
    column: $table.detail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get xpDelta => $composableBuilder(
    column: $table.xpDelta,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActivityLogEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityLogEntriesTable> {
  $$ActivityLogEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detail => $composableBuilder(
    column: $table.detail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get xpDelta => $composableBuilder(
    column: $table.xpDelta,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActivityLogEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityLogEntriesTable> {
  $$ActivityLogEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ActivityKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get detail =>
      $composableBuilder(column: $table.detail, builder: (column) => column);

  GeneratedColumn<int> get xpDelta =>
      $composableBuilder(column: $table.xpDelta, builder: (column) => column);
}

class $$ActivityLogEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivityLogEntriesTable,
          ActivityLogRow,
          $$ActivityLogEntriesTableFilterComposer,
          $$ActivityLogEntriesTableOrderingComposer,
          $$ActivityLogEntriesTableAnnotationComposer,
          $$ActivityLogEntriesTableCreateCompanionBuilder,
          $$ActivityLogEntriesTableUpdateCompanionBuilder,
          (
            ActivityLogRow,
            BaseReferences<
              _$AppDatabase,
              $ActivityLogEntriesTable,
              ActivityLogRow
            >,
          ),
          ActivityLogRow,
          PrefetchHooks Function()
        > {
  $$ActivityLogEntriesTableTableManager(
    _$AppDatabase db,
    $ActivityLogEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityLogEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivityLogEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivityLogEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                Value<ActivityKind> kind = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> detail = const Value.absent(),
                Value<int?> xpDelta = const Value.absent(),
              }) => ActivityLogEntriesCompanion(
                id: id,
                at: at,
                kind: kind,
                title: title,
                detail: detail,
                xpDelta: xpDelta,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime at,
                required ActivityKind kind,
                required String title,
                Value<String?> detail = const Value.absent(),
                Value<int?> xpDelta = const Value.absent(),
              }) => ActivityLogEntriesCompanion.insert(
                id: id,
                at: at,
                kind: kind,
                title: title,
                detail: detail,
                xpDelta: xpDelta,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActivityLogEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivityLogEntriesTable,
      ActivityLogRow,
      $$ActivityLogEntriesTableFilterComposer,
      $$ActivityLogEntriesTableOrderingComposer,
      $$ActivityLogEntriesTableAnnotationComposer,
      $$ActivityLogEntriesTableCreateCompanionBuilder,
      $$ActivityLogEntriesTableUpdateCompanionBuilder,
      (
        ActivityLogRow,
        BaseReferences<_$AppDatabase, $ActivityLogEntriesTable, ActivityLogRow>,
      ),
      ActivityLogRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TaskTemplatesTableTableManager get taskTemplates =>
      $$TaskTemplatesTableTableManager(_db, _db.taskTemplates);
  $$DailyQuestsTableTableManager get dailyQuests =>
      $$DailyQuestsTableTableManager(_db, _db.dailyQuests);
  $$DayRollupsTableTableManager get dayRollups =>
      $$DayRollupsTableTableManager(_db, _db.dayRollups);
  $$PlayerStatesTableTableManager get playerStates =>
      $$PlayerStatesTableTableManager(_db, _db.playerStates);
  $$ActivityLogEntriesTableTableManager get activityLogEntries =>
      $$ActivityLogEntriesTableTableManager(_db, _db.activityLogEntries);
}
