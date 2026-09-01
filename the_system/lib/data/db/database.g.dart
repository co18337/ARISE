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
  static const VerificationMeta _bonusXpMeta = const VerificationMeta(
    'bonusXp',
  );
  @override
  late final GeneratedColumn<int> bonusXp = GeneratedColumn<int>(
    'bonus_xp',
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
    bonusXp,
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
    if (data.containsKey('bonus_xp')) {
      context.handle(
        _bonusXpMeta,
        bonusXp.isAcceptableOrUnknown(data['bonus_xp']!, _bonusXpMeta),
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
      bonusXp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bonus_xp'],
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

  /// XP earned for training beyond the prescription. Added in schema v13.
  ///
  /// Kept SEPARATE from xpEarned on purpose: xpEarned is quest XP and is what
  /// the streak and the perfect-day bar are measured against. Folding bonus
  /// work into it would let an extra ten minutes of walking paper over a day
  /// of missed quests.
  final int bonusXp;

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
    required this.bonusXp,
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
    map['bonus_xp'] = Variable<int>(bonusXp);
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
      bonusXp: Value(bonusXp),
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
      bonusXp: serializer.fromJson<int>(json['bonusXp']),
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
      'bonusXp': serializer.toJson<int>(bonusXp),
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
    int? bonusXp,
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
    bonusXp: bonusXp ?? this.bonusXp,
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
      bonusXp: data.bonusXp.present ? data.bonusXp.value : this.bonusXp,
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
          ..write('bonusXp: $bonusXp, ')
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
    bonusXp,
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
          other.bonusXp == this.bonusXp &&
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
  final Value<int> bonusXp;
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
    this.bonusXp = const Value.absent(),
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
    this.bonusXp = const Value.absent(),
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
    Expression<int>? bonusXp,
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
      if (bonusXp != null) 'bonus_xp': bonusXp,
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
    Value<int>? bonusXp,
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
      bonusXp: bonusXp ?? this.bonusXp,
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
    if (bonusXp.present) {
      map['bonus_xp'] = Variable<int>(bonusXp.value);
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
          ..write('bonusXp: $bonusXp, ')
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
  static const VerificationMeta _programmeStartDayMeta = const VerificationMeta(
    'programmeStartDay',
  );
  @override
  late final GeneratedColumn<int> programmeStartDay = GeneratedColumn<int>(
    'programme_start_day',
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
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('dark'),
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
  static const VerificationMeta _acknowledgedMedalsMeta =
      const VerificationMeta('acknowledgedMedals');
  @override
  late final GeneratedColumn<String> acknowledgedMedals =
      GeneratedColumn<String>(
        'acknowledged_medals',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
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
    questsCleared,
    lastActiveDay,
    programmeStartDay,
    acknowledgedLevel,
    themeMode,
    acknowledgedRank,
    acknowledgedMedals,
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
    if (data.containsKey('quests_cleared')) {
      context.handle(
        _questsClearedMeta,
        questsCleared.isAcceptableOrUnknown(
          data['quests_cleared']!,
          _questsClearedMeta,
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
    if (data.containsKey('programme_start_day')) {
      context.handle(
        _programmeStartDayMeta,
        programmeStartDay.isAcceptableOrUnknown(
          data['programme_start_day']!,
          _programmeStartDayMeta,
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
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
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
    if (data.containsKey('acknowledged_medals')) {
      context.handle(
        _acknowledgedMedalsMeta,
        acknowledgedMedals.isAcceptableOrUnknown(
          data['acknowledged_medals']!,
          _acknowledgedMedalsMeta,
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
      questsCleared: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quests_cleared'],
      )!,
      lastActiveDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_active_day'],
      ),
      programmeStartDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}programme_start_day'],
      ),
      acknowledgedLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}acknowledged_level'],
      )!,
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_mode'],
      )!,
      acknowledgedRank: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}acknowledged_rank'],
      )!,
      acknowledgedMedals: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}acknowledged_medals'],
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

  /// Lifetime quests cleared. Added in schema v4.
  ///
  /// Derivable from the rollups, and the STATUS screen still derives it per
  /// time window. It is kept here because achievement unlocks are detected by
  /// comparing the totals BEFORE a write against the ones after, and "before"
  /// only exists on this row.
  final int questsCleared;

  /// Bonus XP is deliberately NOT mirrored here, unlike questsCleared.
  /// It lives once, on the day rollups, and the lifetime figure is summed
  /// from them in _recomputeProgression. A second copy on this row was
  /// declared in v13, never written, never read, and shipped without a
  /// migration — so every database upgraded to v13 crashed on open. One
  /// number, one home.
  final int? lastActiveDay;

  /// Day the training programme began, which is what phase and week are
  /// counted from. Added in schema v6; null until the first session opens.
  final int? programmeStartDay;
  final int acknowledgedLevel;

  /// Which look the app is wearing: dark | warm | auto. Added in schema v5.
  ///
  /// A UI preference on the player row rather than in its own settings table:
  /// this row is already the single "everything about me" record, and one
  /// column is not worth a second table and a second repository.
  final String themeMode;
  final String acknowledgedRank;

  /// Highest medal tier already celebrated, per medal: `resolve:2,flawless:0`.
  /// Added in schema v8. Bookkeeping for the modals, not history — the medals
  /// themselves are always derived from totals.
  final String acknowledgedMedals;
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
    required this.questsCleared,
    this.lastActiveDay,
    this.programmeStartDay,
    required this.acknowledgedLevel,
    required this.themeMode,
    required this.acknowledgedRank,
    required this.acknowledgedMedals,
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
    map['quests_cleared'] = Variable<int>(questsCleared);
    if (!nullToAbsent || lastActiveDay != null) {
      map['last_active_day'] = Variable<int>(lastActiveDay);
    }
    if (!nullToAbsent || programmeStartDay != null) {
      map['programme_start_day'] = Variable<int>(programmeStartDay);
    }
    map['acknowledged_level'] = Variable<int>(acknowledgedLevel);
    map['theme_mode'] = Variable<String>(themeMode);
    map['acknowledged_rank'] = Variable<String>(acknowledgedRank);
    map['acknowledged_medals'] = Variable<String>(acknowledgedMedals);
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
      questsCleared: Value(questsCleared),
      lastActiveDay: lastActiveDay == null && nullToAbsent
          ? const Value.absent()
          : Value(lastActiveDay),
      programmeStartDay: programmeStartDay == null && nullToAbsent
          ? const Value.absent()
          : Value(programmeStartDay),
      acknowledgedLevel: Value(acknowledgedLevel),
      themeMode: Value(themeMode),
      acknowledgedRank: Value(acknowledgedRank),
      acknowledgedMedals: Value(acknowledgedMedals),
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
      questsCleared: serializer.fromJson<int>(json['questsCleared']),
      lastActiveDay: serializer.fromJson<int?>(json['lastActiveDay']),
      programmeStartDay: serializer.fromJson<int?>(json['programmeStartDay']),
      acknowledgedLevel: serializer.fromJson<int>(json['acknowledgedLevel']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      acknowledgedRank: serializer.fromJson<String>(json['acknowledgedRank']),
      acknowledgedMedals: serializer.fromJson<String>(
        json['acknowledgedMedals'],
      ),
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
      'questsCleared': serializer.toJson<int>(questsCleared),
      'lastActiveDay': serializer.toJson<int?>(lastActiveDay),
      'programmeStartDay': serializer.toJson<int?>(programmeStartDay),
      'acknowledgedLevel': serializer.toJson<int>(acknowledgedLevel),
      'themeMode': serializer.toJson<String>(themeMode),
      'acknowledgedRank': serializer.toJson<String>(acknowledgedRank),
      'acknowledgedMedals': serializer.toJson<String>(acknowledgedMedals),
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
    int? questsCleared,
    Value<int?> lastActiveDay = const Value.absent(),
    Value<int?> programmeStartDay = const Value.absent(),
    int? acknowledgedLevel,
    String? themeMode,
    String? acknowledgedRank,
    String? acknowledgedMedals,
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
    questsCleared: questsCleared ?? this.questsCleared,
    lastActiveDay: lastActiveDay.present
        ? lastActiveDay.value
        : this.lastActiveDay,
    programmeStartDay: programmeStartDay.present
        ? programmeStartDay.value
        : this.programmeStartDay,
    acknowledgedLevel: acknowledgedLevel ?? this.acknowledgedLevel,
    themeMode: themeMode ?? this.themeMode,
    acknowledgedRank: acknowledgedRank ?? this.acknowledgedRank,
    acknowledgedMedals: acknowledgedMedals ?? this.acknowledgedMedals,
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
      questsCleared: data.questsCleared.present
          ? data.questsCleared.value
          : this.questsCleared,
      lastActiveDay: data.lastActiveDay.present
          ? data.lastActiveDay.value
          : this.lastActiveDay,
      programmeStartDay: data.programmeStartDay.present
          ? data.programmeStartDay.value
          : this.programmeStartDay,
      acknowledgedLevel: data.acknowledgedLevel.present
          ? data.acknowledgedLevel.value
          : this.acknowledgedLevel,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      acknowledgedRank: data.acknowledgedRank.present
          ? data.acknowledgedRank.value
          : this.acknowledgedRank,
      acknowledgedMedals: data.acknowledgedMedals.present
          ? data.acknowledgedMedals.value
          : this.acknowledgedMedals,
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
          ..write('questsCleared: $questsCleared, ')
          ..write('lastActiveDay: $lastActiveDay, ')
          ..write('programmeStartDay: $programmeStartDay, ')
          ..write('acknowledgedLevel: $acknowledgedLevel, ')
          ..write('themeMode: $themeMode, ')
          ..write('acknowledgedRank: $acknowledgedRank, ')
          ..write('acknowledgedMedals: $acknowledgedMedals')
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
    questsCleared,
    lastActiveDay,
    programmeStartDay,
    acknowledgedLevel,
    themeMode,
    acknowledgedRank,
    acknowledgedMedals,
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
          other.questsCleared == this.questsCleared &&
          other.lastActiveDay == this.lastActiveDay &&
          other.programmeStartDay == this.programmeStartDay &&
          other.acknowledgedLevel == this.acknowledgedLevel &&
          other.themeMode == this.themeMode &&
          other.acknowledgedRank == this.acknowledgedRank &&
          other.acknowledgedMedals == this.acknowledgedMedals);
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
  final Value<int> questsCleared;
  final Value<int?> lastActiveDay;
  final Value<int?> programmeStartDay;
  final Value<int> acknowledgedLevel;
  final Value<String> themeMode;
  final Value<String> acknowledgedRank;
  final Value<String> acknowledgedMedals;
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
    this.questsCleared = const Value.absent(),
    this.lastActiveDay = const Value.absent(),
    this.programmeStartDay = const Value.absent(),
    this.acknowledgedLevel = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.acknowledgedRank = const Value.absent(),
    this.acknowledgedMedals = const Value.absent(),
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
    this.questsCleared = const Value.absent(),
    this.lastActiveDay = const Value.absent(),
    this.programmeStartDay = const Value.absent(),
    this.acknowledgedLevel = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.acknowledgedRank = const Value.absent(),
    this.acknowledgedMedals = const Value.absent(),
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
    Expression<int>? questsCleared,
    Expression<int>? lastActiveDay,
    Expression<int>? programmeStartDay,
    Expression<int>? acknowledgedLevel,
    Expression<String>? themeMode,
    Expression<String>? acknowledgedRank,
    Expression<String>? acknowledgedMedals,
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
      if (questsCleared != null) 'quests_cleared': questsCleared,
      if (lastActiveDay != null) 'last_active_day': lastActiveDay,
      if (programmeStartDay != null) 'programme_start_day': programmeStartDay,
      if (acknowledgedLevel != null) 'acknowledged_level': acknowledgedLevel,
      if (themeMode != null) 'theme_mode': themeMode,
      if (acknowledgedRank != null) 'acknowledged_rank': acknowledgedRank,
      if (acknowledgedMedals != null) 'acknowledged_medals': acknowledgedMedals,
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
    Value<int>? questsCleared,
    Value<int?>? lastActiveDay,
    Value<int?>? programmeStartDay,
    Value<int>? acknowledgedLevel,
    Value<String>? themeMode,
    Value<String>? acknowledgedRank,
    Value<String>? acknowledgedMedals,
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
      questsCleared: questsCleared ?? this.questsCleared,
      lastActiveDay: lastActiveDay ?? this.lastActiveDay,
      programmeStartDay: programmeStartDay ?? this.programmeStartDay,
      acknowledgedLevel: acknowledgedLevel ?? this.acknowledgedLevel,
      themeMode: themeMode ?? this.themeMode,
      acknowledgedRank: acknowledgedRank ?? this.acknowledgedRank,
      acknowledgedMedals: acknowledgedMedals ?? this.acknowledgedMedals,
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
    if (questsCleared.present) {
      map['quests_cleared'] = Variable<int>(questsCleared.value);
    }
    if (lastActiveDay.present) {
      map['last_active_day'] = Variable<int>(lastActiveDay.value);
    }
    if (programmeStartDay.present) {
      map['programme_start_day'] = Variable<int>(programmeStartDay.value);
    }
    if (acknowledgedLevel.present) {
      map['acknowledged_level'] = Variable<int>(acknowledgedLevel.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (acknowledgedRank.present) {
      map['acknowledged_rank'] = Variable<String>(acknowledgedRank.value);
    }
    if (acknowledgedMedals.present) {
      map['acknowledged_medals'] = Variable<String>(acknowledgedMedals.value);
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
          ..write('questsCleared: $questsCleared, ')
          ..write('lastActiveDay: $lastActiveDay, ')
          ..write('programmeStartDay: $programmeStartDay, ')
          ..write('acknowledgedLevel: $acknowledgedLevel, ')
          ..write('themeMode: $themeMode, ')
          ..write('acknowledgedRank: $acknowledgedRank, ')
          ..write('acknowledgedMedals: $acknowledgedMedals')
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

class $WorkoutSessionsTable extends WorkoutSessions
    with TableInfo<$WorkoutSessionsTable, WorkoutSessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSessionsTable(this.attachedDatabase, [this._alias]);
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
  late final GeneratedColumnWithTypeConverter<TrainingPhase, String> phase =
      GeneratedColumn<String>(
        'phase',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TrainingPhase>($WorkoutSessionsTable.$converterphase);
  static const VerificationMeta _weekMeta = const VerificationMeta('week');
  @override
  late final GeneratedColumn<int> week = GeneratedColumn<int>(
    'week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _focusMeta = const VerificationMeta('focus');
  @override
  late final GeneratedColumn<String> focus = GeneratedColumn<String>(
    'focus',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TrainerNoteSource, String>
  noteSource =
      GeneratedColumn<String>(
        'note_source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('history'),
      ).withConverter<TrainerNoteSource>(
        $WorkoutSessionsTable.$converternoteSource,
      );
  static const VerificationMeta _summonedAtMeta = const VerificationMeta(
    'summonedAt',
  );
  @override
  late final GeneratedColumn<DateTime> summonedAt = GeneratedColumn<DateTime>(
    'summoned_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    day,
    phase,
    week,
    focus,
    notes,
    noteSource,
    summonedAt,
    startedAt,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSessionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('week')) {
      context.handle(
        _weekMeta,
        week.isAcceptableOrUnknown(data['week']!, _weekMeta),
      );
    } else if (isInserting) {
      context.missing(_weekMeta);
    }
    if (data.containsKey('focus')) {
      context.handle(
        _focusMeta,
        focus.isAcceptableOrUnknown(data['focus']!, _focusMeta),
      );
    } else if (isInserting) {
      context.missing(_focusMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('summoned_at')) {
      context.handle(
        _summonedAtMeta,
        summonedAt.isAcceptableOrUnknown(data['summoned_at']!, _summonedAtMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {day},
  ];
  @override
  WorkoutSessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSessionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day'],
      )!,
      phase: $WorkoutSessionsTable.$converterphase.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}phase'],
        )!,
      ),
      week: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}week'],
      )!,
      focus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}focus'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      noteSource: $WorkoutSessionsTable.$converternoteSource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}note_source'],
        )!,
      ),
      summonedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}summoned_at'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $WorkoutSessionsTable createAlias(String alias) {
    return $WorkoutSessionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TrainingPhase, String, String> $converterphase =
      const EnumNameConverter<TrainingPhase>(TrainingPhase.values);
  static JsonTypeConverter2<TrainerNoteSource, String, String>
  $converternoteSource = const EnumNameConverter<TrainerNoteSource>(
    TrainerNoteSource.values,
  );
}

class WorkoutSessionRow extends DataClass
    implements Insertable<WorkoutSessionRow> {
  final int id;

  /// Integer day number — see lib/data/day_key.dart.
  final int day;

  /// Snapshotted at issue time, exactly like a quest's XP: the phase you were
  /// actually in when you trained, not the one you are in now.
  final TrainingPhase phase;
  final int week;
  final String focus;

  /// What the trainer noticed in your history when it issued this session,
  /// newline-separated. Stored rather than recomputed: it was written against
  /// the corpus as it stood that day, and re-deriving it later would quietly
  /// rewrite the past.
  final String? notes;

  /// Whether [notes] were written by the model or copied from the corpus.
  /// Added in schema v12.
  final TrainerNoteSource noteSource;

  /// When ARISE was tapped and the session was accepted.
  ///
  /// The session EXISTS before this — it is built by the rule engine the
  /// moment the day opens, so a dead network or a flat battery still leaves
  /// you a workout. Summoning reveals it and lets the trainer speak; the
  /// ceremony must never be the thing holding the door shut.
  final DateTime? summonedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  const WorkoutSessionRow({
    required this.id,
    required this.day,
    required this.phase,
    required this.week,
    required this.focus,
    this.notes,
    required this.noteSource,
    this.summonedAt,
    this.startedAt,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['day'] = Variable<int>(day);
    {
      map['phase'] = Variable<String>(
        $WorkoutSessionsTable.$converterphase.toSql(phase),
      );
    }
    map['week'] = Variable<int>(week);
    map['focus'] = Variable<String>(focus);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    {
      map['note_source'] = Variable<String>(
        $WorkoutSessionsTable.$converternoteSource.toSql(noteSource),
      );
    }
    if (!nullToAbsent || summonedAt != null) {
      map['summoned_at'] = Variable<DateTime>(summonedAt);
    }
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  WorkoutSessionsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSessionsCompanion(
      id: Value(id),
      day: Value(day),
      phase: Value(phase),
      week: Value(week),
      focus: Value(focus),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      noteSource: Value(noteSource),
      summonedAt: summonedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(summonedAt),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory WorkoutSessionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSessionRow(
      id: serializer.fromJson<int>(json['id']),
      day: serializer.fromJson<int>(json['day']),
      phase: $WorkoutSessionsTable.$converterphase.fromJson(
        serializer.fromJson<String>(json['phase']),
      ),
      week: serializer.fromJson<int>(json['week']),
      focus: serializer.fromJson<String>(json['focus']),
      notes: serializer.fromJson<String?>(json['notes']),
      noteSource: $WorkoutSessionsTable.$converternoteSource.fromJson(
        serializer.fromJson<String>(json['noteSource']),
      ),
      summonedAt: serializer.fromJson<DateTime?>(json['summonedAt']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'day': serializer.toJson<int>(day),
      'phase': serializer.toJson<String>(
        $WorkoutSessionsTable.$converterphase.toJson(phase),
      ),
      'week': serializer.toJson<int>(week),
      'focus': serializer.toJson<String>(focus),
      'notes': serializer.toJson<String?>(notes),
      'noteSource': serializer.toJson<String>(
        $WorkoutSessionsTable.$converternoteSource.toJson(noteSource),
      ),
      'summonedAt': serializer.toJson<DateTime?>(summonedAt),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  WorkoutSessionRow copyWith({
    int? id,
    int? day,
    TrainingPhase? phase,
    int? week,
    String? focus,
    Value<String?> notes = const Value.absent(),
    TrainerNoteSource? noteSource,
    Value<DateTime?> summonedAt = const Value.absent(),
    Value<DateTime?> startedAt = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
  }) => WorkoutSessionRow(
    id: id ?? this.id,
    day: day ?? this.day,
    phase: phase ?? this.phase,
    week: week ?? this.week,
    focus: focus ?? this.focus,
    notes: notes.present ? notes.value : this.notes,
    noteSource: noteSource ?? this.noteSource,
    summonedAt: summonedAt.present ? summonedAt.value : this.summonedAt,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  WorkoutSessionRow copyWithCompanion(WorkoutSessionsCompanion data) {
    return WorkoutSessionRow(
      id: data.id.present ? data.id.value : this.id,
      day: data.day.present ? data.day.value : this.day,
      phase: data.phase.present ? data.phase.value : this.phase,
      week: data.week.present ? data.week.value : this.week,
      focus: data.focus.present ? data.focus.value : this.focus,
      notes: data.notes.present ? data.notes.value : this.notes,
      noteSource: data.noteSource.present
          ? data.noteSource.value
          : this.noteSource,
      summonedAt: data.summonedAt.present
          ? data.summonedAt.value
          : this.summonedAt,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionRow(')
          ..write('id: $id, ')
          ..write('day: $day, ')
          ..write('phase: $phase, ')
          ..write('week: $week, ')
          ..write('focus: $focus, ')
          ..write('notes: $notes, ')
          ..write('noteSource: $noteSource, ')
          ..write('summonedAt: $summonedAt, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    day,
    phase,
    week,
    focus,
    notes,
    noteSource,
    summonedAt,
    startedAt,
    completedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSessionRow &&
          other.id == this.id &&
          other.day == this.day &&
          other.phase == this.phase &&
          other.week == this.week &&
          other.focus == this.focus &&
          other.notes == this.notes &&
          other.noteSource == this.noteSource &&
          other.summonedAt == this.summonedAt &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt);
}

class WorkoutSessionsCompanion extends UpdateCompanion<WorkoutSessionRow> {
  final Value<int> id;
  final Value<int> day;
  final Value<TrainingPhase> phase;
  final Value<int> week;
  final Value<String> focus;
  final Value<String?> notes;
  final Value<TrainerNoteSource> noteSource;
  final Value<DateTime?> summonedAt;
  final Value<DateTime?> startedAt;
  final Value<DateTime?> completedAt;
  const WorkoutSessionsCompanion({
    this.id = const Value.absent(),
    this.day = const Value.absent(),
    this.phase = const Value.absent(),
    this.week = const Value.absent(),
    this.focus = const Value.absent(),
    this.notes = const Value.absent(),
    this.noteSource = const Value.absent(),
    this.summonedAt = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  WorkoutSessionsCompanion.insert({
    this.id = const Value.absent(),
    required int day,
    required TrainingPhase phase,
    required int week,
    required String focus,
    this.notes = const Value.absent(),
    this.noteSource = const Value.absent(),
    this.summonedAt = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
  }) : day = Value(day),
       phase = Value(phase),
       week = Value(week),
       focus = Value(focus);
  static Insertable<WorkoutSessionRow> custom({
    Expression<int>? id,
    Expression<int>? day,
    Expression<String>? phase,
    Expression<int>? week,
    Expression<String>? focus,
    Expression<String>? notes,
    Expression<String>? noteSource,
    Expression<DateTime>? summonedAt,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (day != null) 'day': day,
      if (phase != null) 'phase': phase,
      if (week != null) 'week': week,
      if (focus != null) 'focus': focus,
      if (notes != null) 'notes': notes,
      if (noteSource != null) 'note_source': noteSource,
      if (summonedAt != null) 'summoned_at': summonedAt,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  WorkoutSessionsCompanion copyWith({
    Value<int>? id,
    Value<int>? day,
    Value<TrainingPhase>? phase,
    Value<int>? week,
    Value<String>? focus,
    Value<String?>? notes,
    Value<TrainerNoteSource>? noteSource,
    Value<DateTime?>? summonedAt,
    Value<DateTime?>? startedAt,
    Value<DateTime?>? completedAt,
  }) {
    return WorkoutSessionsCompanion(
      id: id ?? this.id,
      day: day ?? this.day,
      phase: phase ?? this.phase,
      week: week ?? this.week,
      focus: focus ?? this.focus,
      notes: notes ?? this.notes,
      noteSource: noteSource ?? this.noteSource,
      summonedAt: summonedAt ?? this.summonedAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (day.present) {
      map['day'] = Variable<int>(day.value);
    }
    if (phase.present) {
      map['phase'] = Variable<String>(
        $WorkoutSessionsTable.$converterphase.toSql(phase.value),
      );
    }
    if (week.present) {
      map['week'] = Variable<int>(week.value);
    }
    if (focus.present) {
      map['focus'] = Variable<String>(focus.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (noteSource.present) {
      map['note_source'] = Variable<String>(
        $WorkoutSessionsTable.$converternoteSource.toSql(noteSource.value),
      );
    }
    if (summonedAt.present) {
      map['summoned_at'] = Variable<DateTime>(summonedAt.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionsCompanion(')
          ..write('id: $id, ')
          ..write('day: $day, ')
          ..write('phase: $phase, ')
          ..write('week: $week, ')
          ..write('focus: $focus, ')
          ..write('notes: $notes, ')
          ..write('noteSource: $noteSource, ')
          ..write('summonedAt: $summonedAt, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSetsTable extends WorkoutSets
    with TableInfo<$WorkoutSetsTable, WorkoutSetRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSetsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _setIndexMeta = const VerificationMeta(
    'setIndex',
  );
  @override
  late final GeneratedColumn<int> setIndex = GeneratedColumn<int>(
    'set_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetMeta = const VerificationMeta('target');
  @override
  late final GeneratedColumn<int> target = GeneratedColumn<int>(
    'target',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualMeta = const VerificationMeta('actual');
  @override
  late final GeneratedColumn<int> actual = GeneratedColumn<int>(
    'actual',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _loadHalfKgMeta = const VerificationMeta(
    'loadHalfKg',
  );
  @override
  late final GeneratedColumn<int> loadHalfKg = GeneratedColumn<int>(
    'load_half_kg',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _doneMeta = const VerificationMeta('done');
  @override
  late final GeneratedColumn<bool> done = GeneratedColumn<bool>(
    'done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
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
  static const VerificationMeta _isExtraMeta = const VerificationMeta(
    'isExtra',
  );
  @override
  late final GeneratedColumn<bool> isExtra = GeneratedColumn<bool>(
    'is_extra',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_extra" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    exerciseId,
    orderIndex,
    setIndex,
    target,
    actual,
    loadHalfKg,
    done,
    completedAt,
    isExtra,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sets';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSetRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('set_index')) {
      context.handle(
        _setIndexMeta,
        setIndex.isAcceptableOrUnknown(data['set_index']!, _setIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_setIndexMeta);
    }
    if (data.containsKey('target')) {
      context.handle(
        _targetMeta,
        target.isAcceptableOrUnknown(data['target']!, _targetMeta),
      );
    } else if (isInserting) {
      context.missing(_targetMeta);
    }
    if (data.containsKey('actual')) {
      context.handle(
        _actualMeta,
        actual.isAcceptableOrUnknown(data['actual']!, _actualMeta),
      );
    }
    if (data.containsKey('load_half_kg')) {
      context.handle(
        _loadHalfKgMeta,
        loadHalfKg.isAcceptableOrUnknown(
          data['load_half_kg']!,
          _loadHalfKgMeta,
        ),
      );
    }
    if (data.containsKey('done')) {
      context.handle(
        _doneMeta,
        done.isAcceptableOrUnknown(data['done']!, _doneMeta),
      );
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
    if (data.containsKey('is_extra')) {
      context.handle(
        _isExtraMeta,
        isExtra.isAcceptableOrUnknown(data['is_extra']!, _isExtraMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSetRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSetRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      setIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}set_index'],
      )!,
      target: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target'],
      )!,
      actual: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actual'],
      ),
      loadHalfKg: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}load_half_kg'],
      ),
      done: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}done'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      isExtra: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_extra'],
      )!,
    );
  }

  @override
  $WorkoutSetsTable createAlias(String alias) {
    return $WorkoutSetsTable(attachedDatabase, alias);
  }
}

class WorkoutSetRow extends DataClass implements Insertable<WorkoutSetRow> {
  final int id;
  final int sessionId;

  /// Not a foreign key into a table: the exercise library is code, not rows,
  /// and history must survive an exercise being retired from it.
  final String exerciseId;

  /// Position of the exercise in the session, and of the set within it.
  final int orderIndex;
  final int setIndex;

  /// What was asked, and what was actually managed.
  final int target;
  final int? actual;

  /// Weight moved, in units of 0.5 kg — so 27.5 kg is 55.
  ///
  /// INTEGER HALF-KILOS rather than a real: gym plates come in halves and a
  /// float would let 27.500000000000004 into the history, which then reads
  /// back as a different working weight than the one before it.
  ///
  /// Null for anything not loaded — running, planks, push-ups. Progression for
  /// those is reps or minutes, and a weight column full of nulls is the honest
  /// way to say a movement has no weight rather than pretending it is zero.
  final int? loadHalfKg;
  final bool done;
  final DateTime? completedAt;

  /// Work done BEYOND what was prescribed.
  ///
  /// Recorded and rewarded, but deliberately excluded from progressive
  /// overload. Counting six sets as "completed the prescription" would make
  /// the engine ask for more next week — enthusiasm bootstrapping itself into
  /// an injury. Extra work is yours; it does not move the ladder.
  final bool isExtra;
  const WorkoutSetRow({
    required this.id,
    required this.sessionId,
    required this.exerciseId,
    required this.orderIndex,
    required this.setIndex,
    required this.target,
    this.actual,
    this.loadHalfKg,
    required this.done,
    this.completedAt,
    required this.isExtra,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['order_index'] = Variable<int>(orderIndex);
    map['set_index'] = Variable<int>(setIndex);
    map['target'] = Variable<int>(target);
    if (!nullToAbsent || actual != null) {
      map['actual'] = Variable<int>(actual);
    }
    if (!nullToAbsent || loadHalfKg != null) {
      map['load_half_kg'] = Variable<int>(loadHalfKg);
    }
    map['done'] = Variable<bool>(done);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['is_extra'] = Variable<bool>(isExtra);
    return map;
  }

  WorkoutSetsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSetsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      exerciseId: Value(exerciseId),
      orderIndex: Value(orderIndex),
      setIndex: Value(setIndex),
      target: Value(target),
      actual: actual == null && nullToAbsent
          ? const Value.absent()
          : Value(actual),
      loadHalfKg: loadHalfKg == null && nullToAbsent
          ? const Value.absent()
          : Value(loadHalfKg),
      done: Value(done),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      isExtra: Value(isExtra),
    );
  }

  factory WorkoutSetRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSetRow(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      setIndex: serializer.fromJson<int>(json['setIndex']),
      target: serializer.fromJson<int>(json['target']),
      actual: serializer.fromJson<int?>(json['actual']),
      loadHalfKg: serializer.fromJson<int?>(json['loadHalfKg']),
      done: serializer.fromJson<bool>(json['done']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      isExtra: serializer.fromJson<bool>(json['isExtra']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'setIndex': serializer.toJson<int>(setIndex),
      'target': serializer.toJson<int>(target),
      'actual': serializer.toJson<int?>(actual),
      'loadHalfKg': serializer.toJson<int?>(loadHalfKg),
      'done': serializer.toJson<bool>(done),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'isExtra': serializer.toJson<bool>(isExtra),
    };
  }

  WorkoutSetRow copyWith({
    int? id,
    int? sessionId,
    String? exerciseId,
    int? orderIndex,
    int? setIndex,
    int? target,
    Value<int?> actual = const Value.absent(),
    Value<int?> loadHalfKg = const Value.absent(),
    bool? done,
    Value<DateTime?> completedAt = const Value.absent(),
    bool? isExtra,
  }) => WorkoutSetRow(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    exerciseId: exerciseId ?? this.exerciseId,
    orderIndex: orderIndex ?? this.orderIndex,
    setIndex: setIndex ?? this.setIndex,
    target: target ?? this.target,
    actual: actual.present ? actual.value : this.actual,
    loadHalfKg: loadHalfKg.present ? loadHalfKg.value : this.loadHalfKg,
    done: done ?? this.done,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    isExtra: isExtra ?? this.isExtra,
  );
  WorkoutSetRow copyWithCompanion(WorkoutSetsCompanion data) {
    return WorkoutSetRow(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      setIndex: data.setIndex.present ? data.setIndex.value : this.setIndex,
      target: data.target.present ? data.target.value : this.target,
      actual: data.actual.present ? data.actual.value : this.actual,
      loadHalfKg: data.loadHalfKg.present
          ? data.loadHalfKg.value
          : this.loadHalfKg,
      done: data.done.present ? data.done.value : this.done,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      isExtra: data.isExtra.present ? data.isExtra.value : this.isExtra,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSetRow(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('setIndex: $setIndex, ')
          ..write('target: $target, ')
          ..write('actual: $actual, ')
          ..write('loadHalfKg: $loadHalfKg, ')
          ..write('done: $done, ')
          ..write('completedAt: $completedAt, ')
          ..write('isExtra: $isExtra')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    exerciseId,
    orderIndex,
    setIndex,
    target,
    actual,
    loadHalfKg,
    done,
    completedAt,
    isExtra,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSetRow &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.exerciseId == this.exerciseId &&
          other.orderIndex == this.orderIndex &&
          other.setIndex == this.setIndex &&
          other.target == this.target &&
          other.actual == this.actual &&
          other.loadHalfKg == this.loadHalfKg &&
          other.done == this.done &&
          other.completedAt == this.completedAt &&
          other.isExtra == this.isExtra);
}

class WorkoutSetsCompanion extends UpdateCompanion<WorkoutSetRow> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<String> exerciseId;
  final Value<int> orderIndex;
  final Value<int> setIndex;
  final Value<int> target;
  final Value<int?> actual;
  final Value<int?> loadHalfKg;
  final Value<bool> done;
  final Value<DateTime?> completedAt;
  final Value<bool> isExtra;
  const WorkoutSetsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.setIndex = const Value.absent(),
    this.target = const Value.absent(),
    this.actual = const Value.absent(),
    this.loadHalfKg = const Value.absent(),
    this.done = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.isExtra = const Value.absent(),
  });
  WorkoutSetsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required String exerciseId,
    required int orderIndex,
    required int setIndex,
    required int target,
    this.actual = const Value.absent(),
    this.loadHalfKg = const Value.absent(),
    this.done = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.isExtra = const Value.absent(),
  }) : sessionId = Value(sessionId),
       exerciseId = Value(exerciseId),
       orderIndex = Value(orderIndex),
       setIndex = Value(setIndex),
       target = Value(target);
  static Insertable<WorkoutSetRow> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<String>? exerciseId,
    Expression<int>? orderIndex,
    Expression<int>? setIndex,
    Expression<int>? target,
    Expression<int>? actual,
    Expression<int>? loadHalfKg,
    Expression<bool>? done,
    Expression<DateTime>? completedAt,
    Expression<bool>? isExtra,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (orderIndex != null) 'order_index': orderIndex,
      if (setIndex != null) 'set_index': setIndex,
      if (target != null) 'target': target,
      if (actual != null) 'actual': actual,
      if (loadHalfKg != null) 'load_half_kg': loadHalfKg,
      if (done != null) 'done': done,
      if (completedAt != null) 'completed_at': completedAt,
      if (isExtra != null) 'is_extra': isExtra,
    });
  }

  WorkoutSetsCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<String>? exerciseId,
    Value<int>? orderIndex,
    Value<int>? setIndex,
    Value<int>? target,
    Value<int?>? actual,
    Value<int?>? loadHalfKg,
    Value<bool>? done,
    Value<DateTime?>? completedAt,
    Value<bool>? isExtra,
  }) {
    return WorkoutSetsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      exerciseId: exerciseId ?? this.exerciseId,
      orderIndex: orderIndex ?? this.orderIndex,
      setIndex: setIndex ?? this.setIndex,
      target: target ?? this.target,
      actual: actual ?? this.actual,
      loadHalfKg: loadHalfKg ?? this.loadHalfKg,
      done: done ?? this.done,
      completedAt: completedAt ?? this.completedAt,
      isExtra: isExtra ?? this.isExtra,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (setIndex.present) {
      map['set_index'] = Variable<int>(setIndex.value);
    }
    if (target.present) {
      map['target'] = Variable<int>(target.value);
    }
    if (actual.present) {
      map['actual'] = Variable<int>(actual.value);
    }
    if (loadHalfKg.present) {
      map['load_half_kg'] = Variable<int>(loadHalfKg.value);
    }
    if (done.present) {
      map['done'] = Variable<bool>(done.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (isExtra.present) {
      map['is_extra'] = Variable<bool>(isExtra.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSetsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('setIndex: $setIndex, ')
          ..write('target: $target, ')
          ..write('actual: $actual, ')
          ..write('loadHalfKg: $loadHalfKg, ')
          ..write('done: $done, ')
          ..write('completedAt: $completedAt, ')
          ..write('isExtra: $isExtra')
          ..write(')'))
        .toString();
  }
}

class $MemoryDocumentsTable extends MemoryDocuments
    with TableInfo<$MemoryDocumentsTable, MemoryDocumentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemoryDocumentsTable(this.attachedDatabase, [this._alias]);
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
  @override
  late final GeneratedColumnWithTypeConverter<MemoryKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MemoryKind>($MemoryDocumentsTable.$converterkind);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<int> day = GeneratedColumn<int>(
    'day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
  static const VerificationMeta _sourcePathMeta = const VerificationMeta(
    'sourcePath',
  );
  @override
  late final GeneratedColumn<String> sourcePath = GeneratedColumn<String>(
    'source_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _externalIdMeta = const VerificationMeta(
    'externalId',
  );
  @override
  late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
    'external_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    title,
    body,
    day,
    createdAt,
    sourcePath,
    externalId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'memory_documents';
  @override
  VerificationContext validateIntegrity(
    Insertable<MemoryDocumentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
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
    if (data.containsKey('source_path')) {
      context.handle(
        _sourcePathMeta,
        sourcePath.isAcceptableOrUnknown(data['source_path']!, _sourcePathMeta),
      );
    }
    if (data.containsKey('external_id')) {
      context.handle(
        _externalIdMeta,
        externalId.isAcceptableOrUnknown(data['external_id']!, _externalIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {externalId},
  ];
  @override
  MemoryDocumentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemoryDocumentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kind: $MemoryDocumentsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      sourcePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_path'],
      ),
      externalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_id'],
      ),
    );
  }

  @override
  $MemoryDocumentsTable createAlias(String alias) {
    return $MemoryDocumentsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MemoryKind, String, String> $converterkind =
      const EnumNameConverter<MemoryKind>(MemoryKind.values);
}

class MemoryDocumentRow extends DataClass
    implements Insertable<MemoryDocumentRow> {
  final int id;
  final MemoryKind kind;
  final String title;
  final String body;

  /// The day this document is ABOUT, which is not always the day it was
  /// written — a scan uploaded in March can describe January.
  final int? day;
  final DateTime createdAt;

  /// Path to the source file on disk, if there is one. Never the file itself.
  final String? sourcePath;

  /// Caller-supplied identity, so re-ingesting the same thing updates it
  /// instead of duplicating it. Sessions use `session:DAY`, and without it
  /// every app launch would re-import the same history.
  final String? externalId;
  const MemoryDocumentRow({
    required this.id,
    required this.kind,
    required this.title,
    required this.body,
    this.day,
    required this.createdAt,
    this.sourcePath,
    this.externalId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['kind'] = Variable<String>(
        $MemoryDocumentsTable.$converterkind.toSql(kind),
      );
    }
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    if (!nullToAbsent || day != null) {
      map['day'] = Variable<int>(day);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || sourcePath != null) {
      map['source_path'] = Variable<String>(sourcePath);
    }
    if (!nullToAbsent || externalId != null) {
      map['external_id'] = Variable<String>(externalId);
    }
    return map;
  }

  MemoryDocumentsCompanion toCompanion(bool nullToAbsent) {
    return MemoryDocumentsCompanion(
      id: Value(id),
      kind: Value(kind),
      title: Value(title),
      body: Value(body),
      day: day == null && nullToAbsent ? const Value.absent() : Value(day),
      createdAt: Value(createdAt),
      sourcePath: sourcePath == null && nullToAbsent
          ? const Value.absent()
          : Value(sourcePath),
      externalId: externalId == null && nullToAbsent
          ? const Value.absent()
          : Value(externalId),
    );
  }

  factory MemoryDocumentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemoryDocumentRow(
      id: serializer.fromJson<int>(json['id']),
      kind: $MemoryDocumentsTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      day: serializer.fromJson<int?>(json['day']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      sourcePath: serializer.fromJson<String?>(json['sourcePath']),
      externalId: serializer.fromJson<String?>(json['externalId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kind': serializer.toJson<String>(
        $MemoryDocumentsTable.$converterkind.toJson(kind),
      ),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'day': serializer.toJson<int?>(day),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'sourcePath': serializer.toJson<String?>(sourcePath),
      'externalId': serializer.toJson<String?>(externalId),
    };
  }

  MemoryDocumentRow copyWith({
    int? id,
    MemoryKind? kind,
    String? title,
    String? body,
    Value<int?> day = const Value.absent(),
    DateTime? createdAt,
    Value<String?> sourcePath = const Value.absent(),
    Value<String?> externalId = const Value.absent(),
  }) => MemoryDocumentRow(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    title: title ?? this.title,
    body: body ?? this.body,
    day: day.present ? day.value : this.day,
    createdAt: createdAt ?? this.createdAt,
    sourcePath: sourcePath.present ? sourcePath.value : this.sourcePath,
    externalId: externalId.present ? externalId.value : this.externalId,
  );
  MemoryDocumentRow copyWithCompanion(MemoryDocumentsCompanion data) {
    return MemoryDocumentRow(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      day: data.day.present ? data.day.value : this.day,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      sourcePath: data.sourcePath.present
          ? data.sourcePath.value
          : this.sourcePath,
      externalId: data.externalId.present
          ? data.externalId.value
          : this.externalId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemoryDocumentRow(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('day: $day, ')
          ..write('createdAt: $createdAt, ')
          ..write('sourcePath: $sourcePath, ')
          ..write('externalId: $externalId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kind,
    title,
    body,
    day,
    createdAt,
    sourcePath,
    externalId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemoryDocumentRow &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.title == this.title &&
          other.body == this.body &&
          other.day == this.day &&
          other.createdAt == this.createdAt &&
          other.sourcePath == this.sourcePath &&
          other.externalId == this.externalId);
}

class MemoryDocumentsCompanion extends UpdateCompanion<MemoryDocumentRow> {
  final Value<int> id;
  final Value<MemoryKind> kind;
  final Value<String> title;
  final Value<String> body;
  final Value<int?> day;
  final Value<DateTime> createdAt;
  final Value<String?> sourcePath;
  final Value<String?> externalId;
  const MemoryDocumentsCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.day = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.sourcePath = const Value.absent(),
    this.externalId = const Value.absent(),
  });
  MemoryDocumentsCompanion.insert({
    this.id = const Value.absent(),
    required MemoryKind kind,
    required String title,
    required String body,
    this.day = const Value.absent(),
    required DateTime createdAt,
    this.sourcePath = const Value.absent(),
    this.externalId = const Value.absent(),
  }) : kind = Value(kind),
       title = Value(title),
       body = Value(body),
       createdAt = Value(createdAt);
  static Insertable<MemoryDocumentRow> custom({
    Expression<int>? id,
    Expression<String>? kind,
    Expression<String>? title,
    Expression<String>? body,
    Expression<int>? day,
    Expression<DateTime>? createdAt,
    Expression<String>? sourcePath,
    Expression<String>? externalId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (day != null) 'day': day,
      if (createdAt != null) 'created_at': createdAt,
      if (sourcePath != null) 'source_path': sourcePath,
      if (externalId != null) 'external_id': externalId,
    });
  }

  MemoryDocumentsCompanion copyWith({
    Value<int>? id,
    Value<MemoryKind>? kind,
    Value<String>? title,
    Value<String>? body,
    Value<int?>? day,
    Value<DateTime>? createdAt,
    Value<String?>? sourcePath,
    Value<String?>? externalId,
  }) {
    return MemoryDocumentsCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      title: title ?? this.title,
      body: body ?? this.body,
      day: day ?? this.day,
      createdAt: createdAt ?? this.createdAt,
      sourcePath: sourcePath ?? this.sourcePath,
      externalId: externalId ?? this.externalId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $MemoryDocumentsTable.$converterkind.toSql(kind.value),
      );
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (day.present) {
      map['day'] = Variable<int>(day.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (sourcePath.present) {
      map['source_path'] = Variable<String>(sourcePath.value);
    }
    if (externalId.present) {
      map['external_id'] = Variable<String>(externalId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemoryDocumentsCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('day: $day, ')
          ..write('createdAt: $createdAt, ')
          ..write('sourcePath: $sourcePath, ')
          ..write('externalId: $externalId')
          ..write(')'))
        .toString();
  }
}

class $MemoryChunksTable extends MemoryChunks
    with TableInfo<$MemoryChunksTable, MemoryChunkRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemoryChunksTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _documentIdMeta = const VerificationMeta(
    'documentId',
  );
  @override
  late final GeneratedColumn<int> documentId = GeneratedColumn<int>(
    'document_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES memory_documents (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _chunkIndexMeta = const VerificationMeta(
    'chunkIndex',
  );
  @override
  late final GeneratedColumn<int> chunkIndex = GeneratedColumn<int>(
    'chunk_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _embeddingMeta = const VerificationMeta(
    'embedding',
  );
  @override
  late final GeneratedColumn<Uint8List> embedding = GeneratedColumn<Uint8List>(
    'embedding',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dimensionsMeta = const VerificationMeta(
    'dimensions',
  );
  @override
  late final GeneratedColumn<int> dimensions = GeneratedColumn<int>(
    'dimensions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _embedderMeta = const VerificationMeta(
    'embedder',
  );
  @override
  late final GeneratedColumn<String> embedder = GeneratedColumn<String>(
    'embedder',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    documentId,
    chunkIndex,
    content,
    embedding,
    dimensions,
    embedder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'memory_chunks';
  @override
  VerificationContext validateIntegrity(
    Insertable<MemoryChunkRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('document_id')) {
      context.handle(
        _documentIdMeta,
        documentId.isAcceptableOrUnknown(data['document_id']!, _documentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_documentIdMeta);
    }
    if (data.containsKey('chunk_index')) {
      context.handle(
        _chunkIndexMeta,
        chunkIndex.isAcceptableOrUnknown(data['chunk_index']!, _chunkIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_chunkIndexMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('embedding')) {
      context.handle(
        _embeddingMeta,
        embedding.isAcceptableOrUnknown(data['embedding']!, _embeddingMeta),
      );
    } else if (isInserting) {
      context.missing(_embeddingMeta);
    }
    if (data.containsKey('dimensions')) {
      context.handle(
        _dimensionsMeta,
        dimensions.isAcceptableOrUnknown(data['dimensions']!, _dimensionsMeta),
      );
    } else if (isInserting) {
      context.missing(_dimensionsMeta);
    }
    if (data.containsKey('embedder')) {
      context.handle(
        _embedderMeta,
        embedder.isAcceptableOrUnknown(data['embedder']!, _embedderMeta),
      );
    } else if (isInserting) {
      context.missing(_embedderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MemoryChunkRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemoryChunkRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      documentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}document_id'],
      )!,
      chunkIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chunk_index'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      embedding: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}embedding'],
      )!,
      dimensions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dimensions'],
      )!,
      embedder: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}embedder'],
      )!,
    );
  }

  @override
  $MemoryChunksTable createAlias(String alias) {
    return $MemoryChunksTable(attachedDatabase, alias);
  }
}

class MemoryChunkRow extends DataClass implements Insertable<MemoryChunkRow> {
  final int id;
  final int documentId;
  final int chunkIndex;

  /// The slice of text this vector was built from.
  ///
  /// Named `content`, not `text`: a column called `text` makes the body
  /// `text()()` resolve to the getter itself rather than to drift's builder,
  /// and drift fails that by silently generating an EMPTY schema instead of
  /// reporting an error. The same trap waits for any column named after a
  /// column builder.
  final String content;

  /// The vector, as raw float32 bytes.
  final Uint8List embedding;
  final int dimensions;

  /// WHICH embedder produced this vector.
  ///
  /// Vectors from different models are not comparable — a cosine similarity
  /// between a hashed vector and a Gemini one is noise. Recording the producer
  /// is what makes it possible to notice, and to re-embed the corpus when the
  /// embedder changes rather than silently returning nonsense.
  final String embedder;
  const MemoryChunkRow({
    required this.id,
    required this.documentId,
    required this.chunkIndex,
    required this.content,
    required this.embedding,
    required this.dimensions,
    required this.embedder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['document_id'] = Variable<int>(documentId);
    map['chunk_index'] = Variable<int>(chunkIndex);
    map['content'] = Variable<String>(content);
    map['embedding'] = Variable<Uint8List>(embedding);
    map['dimensions'] = Variable<int>(dimensions);
    map['embedder'] = Variable<String>(embedder);
    return map;
  }

  MemoryChunksCompanion toCompanion(bool nullToAbsent) {
    return MemoryChunksCompanion(
      id: Value(id),
      documentId: Value(documentId),
      chunkIndex: Value(chunkIndex),
      content: Value(content),
      embedding: Value(embedding),
      dimensions: Value(dimensions),
      embedder: Value(embedder),
    );
  }

  factory MemoryChunkRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemoryChunkRow(
      id: serializer.fromJson<int>(json['id']),
      documentId: serializer.fromJson<int>(json['documentId']),
      chunkIndex: serializer.fromJson<int>(json['chunkIndex']),
      content: serializer.fromJson<String>(json['content']),
      embedding: serializer.fromJson<Uint8List>(json['embedding']),
      dimensions: serializer.fromJson<int>(json['dimensions']),
      embedder: serializer.fromJson<String>(json['embedder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'documentId': serializer.toJson<int>(documentId),
      'chunkIndex': serializer.toJson<int>(chunkIndex),
      'content': serializer.toJson<String>(content),
      'embedding': serializer.toJson<Uint8List>(embedding),
      'dimensions': serializer.toJson<int>(dimensions),
      'embedder': serializer.toJson<String>(embedder),
    };
  }

  MemoryChunkRow copyWith({
    int? id,
    int? documentId,
    int? chunkIndex,
    String? content,
    Uint8List? embedding,
    int? dimensions,
    String? embedder,
  }) => MemoryChunkRow(
    id: id ?? this.id,
    documentId: documentId ?? this.documentId,
    chunkIndex: chunkIndex ?? this.chunkIndex,
    content: content ?? this.content,
    embedding: embedding ?? this.embedding,
    dimensions: dimensions ?? this.dimensions,
    embedder: embedder ?? this.embedder,
  );
  MemoryChunkRow copyWithCompanion(MemoryChunksCompanion data) {
    return MemoryChunkRow(
      id: data.id.present ? data.id.value : this.id,
      documentId: data.documentId.present
          ? data.documentId.value
          : this.documentId,
      chunkIndex: data.chunkIndex.present
          ? data.chunkIndex.value
          : this.chunkIndex,
      content: data.content.present ? data.content.value : this.content,
      embedding: data.embedding.present ? data.embedding.value : this.embedding,
      dimensions: data.dimensions.present
          ? data.dimensions.value
          : this.dimensions,
      embedder: data.embedder.present ? data.embedder.value : this.embedder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemoryChunkRow(')
          ..write('id: $id, ')
          ..write('documentId: $documentId, ')
          ..write('chunkIndex: $chunkIndex, ')
          ..write('content: $content, ')
          ..write('embedding: $embedding, ')
          ..write('dimensions: $dimensions, ')
          ..write('embedder: $embedder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    documentId,
    chunkIndex,
    content,
    $driftBlobEquality.hash(embedding),
    dimensions,
    embedder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemoryChunkRow &&
          other.id == this.id &&
          other.documentId == this.documentId &&
          other.chunkIndex == this.chunkIndex &&
          other.content == this.content &&
          $driftBlobEquality.equals(other.embedding, this.embedding) &&
          other.dimensions == this.dimensions &&
          other.embedder == this.embedder);
}

class MemoryChunksCompanion extends UpdateCompanion<MemoryChunkRow> {
  final Value<int> id;
  final Value<int> documentId;
  final Value<int> chunkIndex;
  final Value<String> content;
  final Value<Uint8List> embedding;
  final Value<int> dimensions;
  final Value<String> embedder;
  const MemoryChunksCompanion({
    this.id = const Value.absent(),
    this.documentId = const Value.absent(),
    this.chunkIndex = const Value.absent(),
    this.content = const Value.absent(),
    this.embedding = const Value.absent(),
    this.dimensions = const Value.absent(),
    this.embedder = const Value.absent(),
  });
  MemoryChunksCompanion.insert({
    this.id = const Value.absent(),
    required int documentId,
    required int chunkIndex,
    required String content,
    required Uint8List embedding,
    required int dimensions,
    required String embedder,
  }) : documentId = Value(documentId),
       chunkIndex = Value(chunkIndex),
       content = Value(content),
       embedding = Value(embedding),
       dimensions = Value(dimensions),
       embedder = Value(embedder);
  static Insertable<MemoryChunkRow> custom({
    Expression<int>? id,
    Expression<int>? documentId,
    Expression<int>? chunkIndex,
    Expression<String>? content,
    Expression<Uint8List>? embedding,
    Expression<int>? dimensions,
    Expression<String>? embedder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (documentId != null) 'document_id': documentId,
      if (chunkIndex != null) 'chunk_index': chunkIndex,
      if (content != null) 'content': content,
      if (embedding != null) 'embedding': embedding,
      if (dimensions != null) 'dimensions': dimensions,
      if (embedder != null) 'embedder': embedder,
    });
  }

  MemoryChunksCompanion copyWith({
    Value<int>? id,
    Value<int>? documentId,
    Value<int>? chunkIndex,
    Value<String>? content,
    Value<Uint8List>? embedding,
    Value<int>? dimensions,
    Value<String>? embedder,
  }) {
    return MemoryChunksCompanion(
      id: id ?? this.id,
      documentId: documentId ?? this.documentId,
      chunkIndex: chunkIndex ?? this.chunkIndex,
      content: content ?? this.content,
      embedding: embedding ?? this.embedding,
      dimensions: dimensions ?? this.dimensions,
      embedder: embedder ?? this.embedder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (documentId.present) {
      map['document_id'] = Variable<int>(documentId.value);
    }
    if (chunkIndex.present) {
      map['chunk_index'] = Variable<int>(chunkIndex.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (embedding.present) {
      map['embedding'] = Variable<Uint8List>(embedding.value);
    }
    if (dimensions.present) {
      map['dimensions'] = Variable<int>(dimensions.value);
    }
    if (embedder.present) {
      map['embedder'] = Variable<String>(embedder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemoryChunksCompanion(')
          ..write('id: $id, ')
          ..write('documentId: $documentId, ')
          ..write('chunkIndex: $chunkIndex, ')
          ..write('content: $content, ')
          ..write('embedding: $embedding, ')
          ..write('dimensions: $dimensions, ')
          ..write('embedder: $embedder')
          ..write(')'))
        .toString();
  }
}

class $MealsTable extends Meals with TableInfo<$MealsTable, MealRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MealSlot, String> slot =
      GeneratedColumn<String>(
        'slot',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MealSlot>($MealsTable.$converterslot);
  @override
  late final GeneratedColumnWithTypeConverter<List<int>, String> daysOfWeek =
      GeneratedColumn<String>(
        'days_of_week',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      ).withConverter<List<int>>($MealsTable.$converterdaysOfWeek);
  static const VerificationMeta _kcalMeta = const VerificationMeta('kcal');
  @override
  late final GeneratedColumn<int> kcal = GeneratedColumn<int>(
    'kcal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinGMeta = const VerificationMeta(
    'proteinG',
  );
  @override
  late final GeneratedColumn<double> proteinG = GeneratedColumn<double>(
    'protein_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carbsGMeta = const VerificationMeta('carbsG');
  @override
  late final GeneratedColumn<double> carbsG = GeneratedColumn<double>(
    'carbs_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fatGMeta = const VerificationMeta('fatG');
  @override
  late final GeneratedColumn<double> fatG = GeneratedColumn<double>(
    'fat_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fibreGMeta = const VerificationMeta('fibreG');
  @override
  late final GeneratedColumn<double> fibreG = GeneratedColumn<double>(
    'fibre_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detailMeta = const VerificationMeta('detail');
  @override
  late final GeneratedColumn<String> detail = GeneratedColumn<String>(
    'detail',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    slot,
    daysOfWeek,
    kcal,
    proteinG,
    carbsG,
    fatG,
    fibreG,
    detail,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meals';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('kcal')) {
      context.handle(
        _kcalMeta,
        kcal.isAcceptableOrUnknown(data['kcal']!, _kcalMeta),
      );
    } else if (isInserting) {
      context.missing(_kcalMeta);
    }
    if (data.containsKey('protein_g')) {
      context.handle(
        _proteinGMeta,
        proteinG.isAcceptableOrUnknown(data['protein_g']!, _proteinGMeta),
      );
    } else if (isInserting) {
      context.missing(_proteinGMeta);
    }
    if (data.containsKey('carbs_g')) {
      context.handle(
        _carbsGMeta,
        carbsG.isAcceptableOrUnknown(data['carbs_g']!, _carbsGMeta),
      );
    } else if (isInserting) {
      context.missing(_carbsGMeta);
    }
    if (data.containsKey('fat_g')) {
      context.handle(
        _fatGMeta,
        fatG.isAcceptableOrUnknown(data['fat_g']!, _fatGMeta),
      );
    } else if (isInserting) {
      context.missing(_fatGMeta);
    }
    if (data.containsKey('fibre_g')) {
      context.handle(
        _fibreGMeta,
        fibreG.isAcceptableOrUnknown(data['fibre_g']!, _fibreGMeta),
      );
    } else if (isInserting) {
      context.missing(_fibreGMeta);
    }
    if (data.containsKey('detail')) {
      context.handle(
        _detailMeta,
        detail.isAcceptableOrUnknown(data['detail']!, _detailMeta),
      );
    } else if (isInserting) {
      context.missing(_detailMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      slot: $MealsTable.$converterslot.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}slot'],
        )!,
      ),
      daysOfWeek: $MealsTable.$converterdaysOfWeek.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}days_of_week'],
        )!,
      ),
      kcal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kcal'],
      )!,
      proteinG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_g'],
      )!,
      carbsG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs_g'],
      )!,
      fatG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_g'],
      )!,
      fibreG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fibre_g'],
      )!,
      detail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detail'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $MealsTable createAlias(String alias) {
    return $MealsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MealSlot, String, String> $converterslot =
      const EnumNameConverter<MealSlot>(MealSlot.values);
  static TypeConverter<List<int>, String> $converterdaysOfWeek =
      const DaysOfWeekConverter();
}

class MealRow extends DataClass implements Insertable<MealRow> {
  final String id;
  final String name;
  final MealSlot slot;

  /// Weekdays this meal is served on, 1 = Monday. Empty means every day.
  final List<int> daysOfWeek;
  final int kcal;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final double fibreG;
  final String detail;
  final bool isActive;
  const MealRow({
    required this.id,
    required this.name,
    required this.slot,
    required this.daysOfWeek,
    required this.kcal,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.fibreG,
    required this.detail,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    {
      map['slot'] = Variable<String>($MealsTable.$converterslot.toSql(slot));
    }
    {
      map['days_of_week'] = Variable<String>(
        $MealsTable.$converterdaysOfWeek.toSql(daysOfWeek),
      );
    }
    map['kcal'] = Variable<int>(kcal);
    map['protein_g'] = Variable<double>(proteinG);
    map['carbs_g'] = Variable<double>(carbsG);
    map['fat_g'] = Variable<double>(fatG);
    map['fibre_g'] = Variable<double>(fibreG);
    map['detail'] = Variable<String>(detail);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  MealsCompanion toCompanion(bool nullToAbsent) {
    return MealsCompanion(
      id: Value(id),
      name: Value(name),
      slot: Value(slot),
      daysOfWeek: Value(daysOfWeek),
      kcal: Value(kcal),
      proteinG: Value(proteinG),
      carbsG: Value(carbsG),
      fatG: Value(fatG),
      fibreG: Value(fibreG),
      detail: Value(detail),
      isActive: Value(isActive),
    );
  }

  factory MealRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      slot: $MealsTable.$converterslot.fromJson(
        serializer.fromJson<String>(json['slot']),
      ),
      daysOfWeek: serializer.fromJson<List<int>>(json['daysOfWeek']),
      kcal: serializer.fromJson<int>(json['kcal']),
      proteinG: serializer.fromJson<double>(json['proteinG']),
      carbsG: serializer.fromJson<double>(json['carbsG']),
      fatG: serializer.fromJson<double>(json['fatG']),
      fibreG: serializer.fromJson<double>(json['fibreG']),
      detail: serializer.fromJson<String>(json['detail']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'slot': serializer.toJson<String>(
        $MealsTable.$converterslot.toJson(slot),
      ),
      'daysOfWeek': serializer.toJson<List<int>>(daysOfWeek),
      'kcal': serializer.toJson<int>(kcal),
      'proteinG': serializer.toJson<double>(proteinG),
      'carbsG': serializer.toJson<double>(carbsG),
      'fatG': serializer.toJson<double>(fatG),
      'fibreG': serializer.toJson<double>(fibreG),
      'detail': serializer.toJson<String>(detail),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  MealRow copyWith({
    String? id,
    String? name,
    MealSlot? slot,
    List<int>? daysOfWeek,
    int? kcal,
    double? proteinG,
    double? carbsG,
    double? fatG,
    double? fibreG,
    String? detail,
    bool? isActive,
  }) => MealRow(
    id: id ?? this.id,
    name: name ?? this.name,
    slot: slot ?? this.slot,
    daysOfWeek: daysOfWeek ?? this.daysOfWeek,
    kcal: kcal ?? this.kcal,
    proteinG: proteinG ?? this.proteinG,
    carbsG: carbsG ?? this.carbsG,
    fatG: fatG ?? this.fatG,
    fibreG: fibreG ?? this.fibreG,
    detail: detail ?? this.detail,
    isActive: isActive ?? this.isActive,
  );
  MealRow copyWithCompanion(MealsCompanion data) {
    return MealRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      slot: data.slot.present ? data.slot.value : this.slot,
      daysOfWeek: data.daysOfWeek.present
          ? data.daysOfWeek.value
          : this.daysOfWeek,
      kcal: data.kcal.present ? data.kcal.value : this.kcal,
      proteinG: data.proteinG.present ? data.proteinG.value : this.proteinG,
      carbsG: data.carbsG.present ? data.carbsG.value : this.carbsG,
      fatG: data.fatG.present ? data.fatG.value : this.fatG,
      fibreG: data.fibreG.present ? data.fibreG.value : this.fibreG,
      detail: data.detail.present ? data.detail.value : this.detail,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('slot: $slot, ')
          ..write('daysOfWeek: $daysOfWeek, ')
          ..write('kcal: $kcal, ')
          ..write('proteinG: $proteinG, ')
          ..write('carbsG: $carbsG, ')
          ..write('fatG: $fatG, ')
          ..write('fibreG: $fibreG, ')
          ..write('detail: $detail, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    slot,
    daysOfWeek,
    kcal,
    proteinG,
    carbsG,
    fatG,
    fibreG,
    detail,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.slot == this.slot &&
          other.daysOfWeek == this.daysOfWeek &&
          other.kcal == this.kcal &&
          other.proteinG == this.proteinG &&
          other.carbsG == this.carbsG &&
          other.fatG == this.fatG &&
          other.fibreG == this.fibreG &&
          other.detail == this.detail &&
          other.isActive == this.isActive);
}

class MealsCompanion extends UpdateCompanion<MealRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<MealSlot> slot;
  final Value<List<int>> daysOfWeek;
  final Value<int> kcal;
  final Value<double> proteinG;
  final Value<double> carbsG;
  final Value<double> fatG;
  final Value<double> fibreG;
  final Value<String> detail;
  final Value<bool> isActive;
  final Value<int> rowid;
  const MealsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.slot = const Value.absent(),
    this.daysOfWeek = const Value.absent(),
    this.kcal = const Value.absent(),
    this.proteinG = const Value.absent(),
    this.carbsG = const Value.absent(),
    this.fatG = const Value.absent(),
    this.fibreG = const Value.absent(),
    this.detail = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MealsCompanion.insert({
    required String id,
    required String name,
    required MealSlot slot,
    this.daysOfWeek = const Value.absent(),
    required int kcal,
    required double proteinG,
    required double carbsG,
    required double fatG,
    required double fibreG,
    required String detail,
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       slot = Value(slot),
       kcal = Value(kcal),
       proteinG = Value(proteinG),
       carbsG = Value(carbsG),
       fatG = Value(fatG),
       fibreG = Value(fibreG),
       detail = Value(detail);
  static Insertable<MealRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? slot,
    Expression<String>? daysOfWeek,
    Expression<int>? kcal,
    Expression<double>? proteinG,
    Expression<double>? carbsG,
    Expression<double>? fatG,
    Expression<double>? fibreG,
    Expression<String>? detail,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (slot != null) 'slot': slot,
      if (daysOfWeek != null) 'days_of_week': daysOfWeek,
      if (kcal != null) 'kcal': kcal,
      if (proteinG != null) 'protein_g': proteinG,
      if (carbsG != null) 'carbs_g': carbsG,
      if (fatG != null) 'fat_g': fatG,
      if (fibreG != null) 'fibre_g': fibreG,
      if (detail != null) 'detail': detail,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MealsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<MealSlot>? slot,
    Value<List<int>>? daysOfWeek,
    Value<int>? kcal,
    Value<double>? proteinG,
    Value<double>? carbsG,
    Value<double>? fatG,
    Value<double>? fibreG,
    Value<String>? detail,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return MealsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      slot: slot ?? this.slot,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      kcal: kcal ?? this.kcal,
      proteinG: proteinG ?? this.proteinG,
      carbsG: carbsG ?? this.carbsG,
      fatG: fatG ?? this.fatG,
      fibreG: fibreG ?? this.fibreG,
      detail: detail ?? this.detail,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (slot.present) {
      map['slot'] = Variable<String>(
        $MealsTable.$converterslot.toSql(slot.value),
      );
    }
    if (daysOfWeek.present) {
      map['days_of_week'] = Variable<String>(
        $MealsTable.$converterdaysOfWeek.toSql(daysOfWeek.value),
      );
    }
    if (kcal.present) {
      map['kcal'] = Variable<int>(kcal.value);
    }
    if (proteinG.present) {
      map['protein_g'] = Variable<double>(proteinG.value);
    }
    if (carbsG.present) {
      map['carbs_g'] = Variable<double>(carbsG.value);
    }
    if (fatG.present) {
      map['fat_g'] = Variable<double>(fatG.value);
    }
    if (fibreG.present) {
      map['fibre_g'] = Variable<double>(fibreG.value);
    }
    if (detail.present) {
      map['detail'] = Variable<String>(detail.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('slot: $slot, ')
          ..write('daysOfWeek: $daysOfWeek, ')
          ..write('kcal: $kcal, ')
          ..write('proteinG: $proteinG, ')
          ..write('carbsG: $carbsG, ')
          ..write('fatG: $fatG, ')
          ..write('fibreG: $fibreG, ')
          ..write('detail: $detail, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FoodLogEntriesTable extends FoodLogEntries
    with TableInfo<$FoodLogEntriesTable, FoodLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodLogEntriesTable(this.attachedDatabase, [this._alias]);
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
  late final GeneratedColumnWithTypeConverter<MealSlot, String> slot =
      GeneratedColumn<String>(
        'slot',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MealSlot>($FoodLogEntriesTable.$converterslot);
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loggedAtMeta = const VerificationMeta(
    'loggedAt',
  );
  @override
  late final GeneratedColumn<DateTime> loggedAt = GeneratedColumn<DateTime>(
    'logged_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MacroSource, String> macroSource =
      GeneratedColumn<String>(
        'macro_source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('none'),
      ).withConverter<MacroSource>($FoodLogEntriesTable.$convertermacroSource);
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
    'confidence',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kcalMeta = const VerificationMeta('kcal');
  @override
  late final GeneratedColumn<int> kcal = GeneratedColumn<int>(
    'kcal',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _proteinGMeta = const VerificationMeta(
    'proteinG',
  );
  @override
  late final GeneratedColumn<double> proteinG = GeneratedColumn<double>(
    'protein_g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _carbsGMeta = const VerificationMeta('carbsG');
  @override
  late final GeneratedColumn<double> carbsG = GeneratedColumn<double>(
    'carbs_g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fatGMeta = const VerificationMeta('fatG');
  @override
  late final GeneratedColumn<double> fatG = GeneratedColumn<double>(
    'fat_g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fibreGMeta = const VerificationMeta('fibreG');
  @override
  late final GeneratedColumn<double> fibreG = GeneratedColumn<double>(
    'fibre_g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _itemsMeta = const VerificationMeta('items');
  @override
  late final GeneratedColumn<String> items = GeneratedColumn<String>(
    'items',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _analysisErrorMeta = const VerificationMeta(
    'analysisError',
  );
  @override
  late final GeneratedColumn<String> analysisError = GeneratedColumn<String>(
    'analysis_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    day,
    slot,
    body,
    loggedAt,
    macroSource,
    confidence,
    kcal,
    proteinG,
    carbsG,
    fatG,
    fibreG,
    items,
    analysisError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'food_log_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<FoodLogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('logged_at')) {
      context.handle(
        _loggedAtMeta,
        loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_loggedAtMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    if (data.containsKey('kcal')) {
      context.handle(
        _kcalMeta,
        kcal.isAcceptableOrUnknown(data['kcal']!, _kcalMeta),
      );
    }
    if (data.containsKey('protein_g')) {
      context.handle(
        _proteinGMeta,
        proteinG.isAcceptableOrUnknown(data['protein_g']!, _proteinGMeta),
      );
    }
    if (data.containsKey('carbs_g')) {
      context.handle(
        _carbsGMeta,
        carbsG.isAcceptableOrUnknown(data['carbs_g']!, _carbsGMeta),
      );
    }
    if (data.containsKey('fat_g')) {
      context.handle(
        _fatGMeta,
        fatG.isAcceptableOrUnknown(data['fat_g']!, _fatGMeta),
      );
    }
    if (data.containsKey('fibre_g')) {
      context.handle(
        _fibreGMeta,
        fibreG.isAcceptableOrUnknown(data['fibre_g']!, _fibreGMeta),
      );
    }
    if (data.containsKey('items')) {
      context.handle(
        _itemsMeta,
        items.isAcceptableOrUnknown(data['items']!, _itemsMeta),
      );
    }
    if (data.containsKey('analysis_error')) {
      context.handle(
        _analysisErrorMeta,
        analysisError.isAcceptableOrUnknown(
          data['analysis_error']!,
          _analysisErrorMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FoodLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodLogRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day'],
      )!,
      slot: $FoodLogEntriesTable.$converterslot.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}slot'],
        )!,
      ),
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      loggedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}logged_at'],
      )!,
      macroSource: $FoodLogEntriesTable.$convertermacroSource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}macro_source'],
        )!,
      ),
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence'],
      ),
      kcal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kcal'],
      ),
      proteinG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_g'],
      ),
      carbsG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs_g'],
      ),
      fatG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_g'],
      ),
      fibreG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fibre_g'],
      ),
      items: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}items'],
      ),
      analysisError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}analysis_error'],
      ),
    );
  }

  @override
  $FoodLogEntriesTable createAlias(String alias) {
    return $FoodLogEntriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MealSlot, String, String> $converterslot =
      const EnumNameConverter<MealSlot>(MealSlot.values);
  static JsonTypeConverter2<MacroSource, String, String> $convertermacroSource =
      const EnumNameConverter<MacroSource>(MacroSource.values);
}

class FoodLogRow extends DataClass implements Insertable<FoodLogRow> {
  final int id;

  /// Integer day number — see lib/data/day_key.dart.
  final int day;
  final MealSlot slot;

  /// Named `body`, not `text`: a column called `text` makes `text()()` resolve
  /// to the getter itself rather than drift's builder, and drift fails that by
  /// silently generating an EMPTY schema.
  final String body;
  final DateTime loggedAt;

  /// Where the macros came from: nothing yet, the model, or typed by hand.
  final MacroSource macroSource;

  /// The model's own confidence, 0..1. Null when a person typed the numbers.
  final double? confidence;
  final int? kcal;
  final double? proteinG;
  final double? carbsG;
  final double? fatG;
  final double? fibreG;

  /// Per-item breakdown as JSON, so "2 chapatis + tea" can be shown itemised
  /// rather than as one opaque total.
  final String? items;

  /// Why the last analysis failed, if it did. Shown rather than swallowed.
  final String? analysisError;
  const FoodLogRow({
    required this.id,
    required this.day,
    required this.slot,
    required this.body,
    required this.loggedAt,
    required this.macroSource,
    this.confidence,
    this.kcal,
    this.proteinG,
    this.carbsG,
    this.fatG,
    this.fibreG,
    this.items,
    this.analysisError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['day'] = Variable<int>(day);
    {
      map['slot'] = Variable<String>(
        $FoodLogEntriesTable.$converterslot.toSql(slot),
      );
    }
    map['body'] = Variable<String>(body);
    map['logged_at'] = Variable<DateTime>(loggedAt);
    {
      map['macro_source'] = Variable<String>(
        $FoodLogEntriesTable.$convertermacroSource.toSql(macroSource),
      );
    }
    if (!nullToAbsent || confidence != null) {
      map['confidence'] = Variable<double>(confidence);
    }
    if (!nullToAbsent || kcal != null) {
      map['kcal'] = Variable<int>(kcal);
    }
    if (!nullToAbsent || proteinG != null) {
      map['protein_g'] = Variable<double>(proteinG);
    }
    if (!nullToAbsent || carbsG != null) {
      map['carbs_g'] = Variable<double>(carbsG);
    }
    if (!nullToAbsent || fatG != null) {
      map['fat_g'] = Variable<double>(fatG);
    }
    if (!nullToAbsent || fibreG != null) {
      map['fibre_g'] = Variable<double>(fibreG);
    }
    if (!nullToAbsent || items != null) {
      map['items'] = Variable<String>(items);
    }
    if (!nullToAbsent || analysisError != null) {
      map['analysis_error'] = Variable<String>(analysisError);
    }
    return map;
  }

  FoodLogEntriesCompanion toCompanion(bool nullToAbsent) {
    return FoodLogEntriesCompanion(
      id: Value(id),
      day: Value(day),
      slot: Value(slot),
      body: Value(body),
      loggedAt: Value(loggedAt),
      macroSource: Value(macroSource),
      confidence: confidence == null && nullToAbsent
          ? const Value.absent()
          : Value(confidence),
      kcal: kcal == null && nullToAbsent ? const Value.absent() : Value(kcal),
      proteinG: proteinG == null && nullToAbsent
          ? const Value.absent()
          : Value(proteinG),
      carbsG: carbsG == null && nullToAbsent
          ? const Value.absent()
          : Value(carbsG),
      fatG: fatG == null && nullToAbsent ? const Value.absent() : Value(fatG),
      fibreG: fibreG == null && nullToAbsent
          ? const Value.absent()
          : Value(fibreG),
      items: items == null && nullToAbsent
          ? const Value.absent()
          : Value(items),
      analysisError: analysisError == null && nullToAbsent
          ? const Value.absent()
          : Value(analysisError),
    );
  }

  factory FoodLogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodLogRow(
      id: serializer.fromJson<int>(json['id']),
      day: serializer.fromJson<int>(json['day']),
      slot: $FoodLogEntriesTable.$converterslot.fromJson(
        serializer.fromJson<String>(json['slot']),
      ),
      body: serializer.fromJson<String>(json['body']),
      loggedAt: serializer.fromJson<DateTime>(json['loggedAt']),
      macroSource: $FoodLogEntriesTable.$convertermacroSource.fromJson(
        serializer.fromJson<String>(json['macroSource']),
      ),
      confidence: serializer.fromJson<double?>(json['confidence']),
      kcal: serializer.fromJson<int?>(json['kcal']),
      proteinG: serializer.fromJson<double?>(json['proteinG']),
      carbsG: serializer.fromJson<double?>(json['carbsG']),
      fatG: serializer.fromJson<double?>(json['fatG']),
      fibreG: serializer.fromJson<double?>(json['fibreG']),
      items: serializer.fromJson<String?>(json['items']),
      analysisError: serializer.fromJson<String?>(json['analysisError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'day': serializer.toJson<int>(day),
      'slot': serializer.toJson<String>(
        $FoodLogEntriesTable.$converterslot.toJson(slot),
      ),
      'body': serializer.toJson<String>(body),
      'loggedAt': serializer.toJson<DateTime>(loggedAt),
      'macroSource': serializer.toJson<String>(
        $FoodLogEntriesTable.$convertermacroSource.toJson(macroSource),
      ),
      'confidence': serializer.toJson<double?>(confidence),
      'kcal': serializer.toJson<int?>(kcal),
      'proteinG': serializer.toJson<double?>(proteinG),
      'carbsG': serializer.toJson<double?>(carbsG),
      'fatG': serializer.toJson<double?>(fatG),
      'fibreG': serializer.toJson<double?>(fibreG),
      'items': serializer.toJson<String?>(items),
      'analysisError': serializer.toJson<String?>(analysisError),
    };
  }

  FoodLogRow copyWith({
    int? id,
    int? day,
    MealSlot? slot,
    String? body,
    DateTime? loggedAt,
    MacroSource? macroSource,
    Value<double?> confidence = const Value.absent(),
    Value<int?> kcal = const Value.absent(),
    Value<double?> proteinG = const Value.absent(),
    Value<double?> carbsG = const Value.absent(),
    Value<double?> fatG = const Value.absent(),
    Value<double?> fibreG = const Value.absent(),
    Value<String?> items = const Value.absent(),
    Value<String?> analysisError = const Value.absent(),
  }) => FoodLogRow(
    id: id ?? this.id,
    day: day ?? this.day,
    slot: slot ?? this.slot,
    body: body ?? this.body,
    loggedAt: loggedAt ?? this.loggedAt,
    macroSource: macroSource ?? this.macroSource,
    confidence: confidence.present ? confidence.value : this.confidence,
    kcal: kcal.present ? kcal.value : this.kcal,
    proteinG: proteinG.present ? proteinG.value : this.proteinG,
    carbsG: carbsG.present ? carbsG.value : this.carbsG,
    fatG: fatG.present ? fatG.value : this.fatG,
    fibreG: fibreG.present ? fibreG.value : this.fibreG,
    items: items.present ? items.value : this.items,
    analysisError: analysisError.present
        ? analysisError.value
        : this.analysisError,
  );
  FoodLogRow copyWithCompanion(FoodLogEntriesCompanion data) {
    return FoodLogRow(
      id: data.id.present ? data.id.value : this.id,
      day: data.day.present ? data.day.value : this.day,
      slot: data.slot.present ? data.slot.value : this.slot,
      body: data.body.present ? data.body.value : this.body,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
      macroSource: data.macroSource.present
          ? data.macroSource.value
          : this.macroSource,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      kcal: data.kcal.present ? data.kcal.value : this.kcal,
      proteinG: data.proteinG.present ? data.proteinG.value : this.proteinG,
      carbsG: data.carbsG.present ? data.carbsG.value : this.carbsG,
      fatG: data.fatG.present ? data.fatG.value : this.fatG,
      fibreG: data.fibreG.present ? data.fibreG.value : this.fibreG,
      items: data.items.present ? data.items.value : this.items,
      analysisError: data.analysisError.present
          ? data.analysisError.value
          : this.analysisError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoodLogRow(')
          ..write('id: $id, ')
          ..write('day: $day, ')
          ..write('slot: $slot, ')
          ..write('body: $body, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('macroSource: $macroSource, ')
          ..write('confidence: $confidence, ')
          ..write('kcal: $kcal, ')
          ..write('proteinG: $proteinG, ')
          ..write('carbsG: $carbsG, ')
          ..write('fatG: $fatG, ')
          ..write('fibreG: $fibreG, ')
          ..write('items: $items, ')
          ..write('analysisError: $analysisError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    day,
    slot,
    body,
    loggedAt,
    macroSource,
    confidence,
    kcal,
    proteinG,
    carbsG,
    fatG,
    fibreG,
    items,
    analysisError,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodLogRow &&
          other.id == this.id &&
          other.day == this.day &&
          other.slot == this.slot &&
          other.body == this.body &&
          other.loggedAt == this.loggedAt &&
          other.macroSource == this.macroSource &&
          other.confidence == this.confidence &&
          other.kcal == this.kcal &&
          other.proteinG == this.proteinG &&
          other.carbsG == this.carbsG &&
          other.fatG == this.fatG &&
          other.fibreG == this.fibreG &&
          other.items == this.items &&
          other.analysisError == this.analysisError);
}

class FoodLogEntriesCompanion extends UpdateCompanion<FoodLogRow> {
  final Value<int> id;
  final Value<int> day;
  final Value<MealSlot> slot;
  final Value<String> body;
  final Value<DateTime> loggedAt;
  final Value<MacroSource> macroSource;
  final Value<double?> confidence;
  final Value<int?> kcal;
  final Value<double?> proteinG;
  final Value<double?> carbsG;
  final Value<double?> fatG;
  final Value<double?> fibreG;
  final Value<String?> items;
  final Value<String?> analysisError;
  const FoodLogEntriesCompanion({
    this.id = const Value.absent(),
    this.day = const Value.absent(),
    this.slot = const Value.absent(),
    this.body = const Value.absent(),
    this.loggedAt = const Value.absent(),
    this.macroSource = const Value.absent(),
    this.confidence = const Value.absent(),
    this.kcal = const Value.absent(),
    this.proteinG = const Value.absent(),
    this.carbsG = const Value.absent(),
    this.fatG = const Value.absent(),
    this.fibreG = const Value.absent(),
    this.items = const Value.absent(),
    this.analysisError = const Value.absent(),
  });
  FoodLogEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int day,
    required MealSlot slot,
    required String body,
    required DateTime loggedAt,
    this.macroSource = const Value.absent(),
    this.confidence = const Value.absent(),
    this.kcal = const Value.absent(),
    this.proteinG = const Value.absent(),
    this.carbsG = const Value.absent(),
    this.fatG = const Value.absent(),
    this.fibreG = const Value.absent(),
    this.items = const Value.absent(),
    this.analysisError = const Value.absent(),
  }) : day = Value(day),
       slot = Value(slot),
       body = Value(body),
       loggedAt = Value(loggedAt);
  static Insertable<FoodLogRow> custom({
    Expression<int>? id,
    Expression<int>? day,
    Expression<String>? slot,
    Expression<String>? body,
    Expression<DateTime>? loggedAt,
    Expression<String>? macroSource,
    Expression<double>? confidence,
    Expression<int>? kcal,
    Expression<double>? proteinG,
    Expression<double>? carbsG,
    Expression<double>? fatG,
    Expression<double>? fibreG,
    Expression<String>? items,
    Expression<String>? analysisError,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (day != null) 'day': day,
      if (slot != null) 'slot': slot,
      if (body != null) 'body': body,
      if (loggedAt != null) 'logged_at': loggedAt,
      if (macroSource != null) 'macro_source': macroSource,
      if (confidence != null) 'confidence': confidence,
      if (kcal != null) 'kcal': kcal,
      if (proteinG != null) 'protein_g': proteinG,
      if (carbsG != null) 'carbs_g': carbsG,
      if (fatG != null) 'fat_g': fatG,
      if (fibreG != null) 'fibre_g': fibreG,
      if (items != null) 'items': items,
      if (analysisError != null) 'analysis_error': analysisError,
    });
  }

  FoodLogEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? day,
    Value<MealSlot>? slot,
    Value<String>? body,
    Value<DateTime>? loggedAt,
    Value<MacroSource>? macroSource,
    Value<double?>? confidence,
    Value<int?>? kcal,
    Value<double?>? proteinG,
    Value<double?>? carbsG,
    Value<double?>? fatG,
    Value<double?>? fibreG,
    Value<String?>? items,
    Value<String?>? analysisError,
  }) {
    return FoodLogEntriesCompanion(
      id: id ?? this.id,
      day: day ?? this.day,
      slot: slot ?? this.slot,
      body: body ?? this.body,
      loggedAt: loggedAt ?? this.loggedAt,
      macroSource: macroSource ?? this.macroSource,
      confidence: confidence ?? this.confidence,
      kcal: kcal ?? this.kcal,
      proteinG: proteinG ?? this.proteinG,
      carbsG: carbsG ?? this.carbsG,
      fatG: fatG ?? this.fatG,
      fibreG: fibreG ?? this.fibreG,
      items: items ?? this.items,
      analysisError: analysisError ?? this.analysisError,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (day.present) {
      map['day'] = Variable<int>(day.value);
    }
    if (slot.present) {
      map['slot'] = Variable<String>(
        $FoodLogEntriesTable.$converterslot.toSql(slot.value),
      );
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<DateTime>(loggedAt.value);
    }
    if (macroSource.present) {
      map['macro_source'] = Variable<String>(
        $FoodLogEntriesTable.$convertermacroSource.toSql(macroSource.value),
      );
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (kcal.present) {
      map['kcal'] = Variable<int>(kcal.value);
    }
    if (proteinG.present) {
      map['protein_g'] = Variable<double>(proteinG.value);
    }
    if (carbsG.present) {
      map['carbs_g'] = Variable<double>(carbsG.value);
    }
    if (fatG.present) {
      map['fat_g'] = Variable<double>(fatG.value);
    }
    if (fibreG.present) {
      map['fibre_g'] = Variable<double>(fibreG.value);
    }
    if (items.present) {
      map['items'] = Variable<String>(items.value);
    }
    if (analysisError.present) {
      map['analysis_error'] = Variable<String>(analysisError.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodLogEntriesCompanion(')
          ..write('id: $id, ')
          ..write('day: $day, ')
          ..write('slot: $slot, ')
          ..write('body: $body, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('macroSource: $macroSource, ')
          ..write('confidence: $confidence, ')
          ..write('kcal: $kcal, ')
          ..write('proteinG: $proteinG, ')
          ..write('carbsG: $carbsG, ')
          ..write('fatG: $fatG, ')
          ..write('fibreG: $fibreG, ')
          ..write('items: $items, ')
          ..write('analysisError: $analysisError')
          ..write(')'))
        .toString();
  }
}

class $AiCallsTable extends AiCalls with TableInfo<$AiCallsTable, AiCallRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiCallsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _laneMeta = const VerificationMeta('lane');
  @override
  late final GeneratedColumn<String> lane = GeneratedColumn<String>(
    'lane',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _okMeta = const VerificationMeta('ok');
  @override
  late final GeneratedColumn<bool> ok = GeneratedColumn<bool>(
    'ok',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ok" IN (0, 1))',
    ),
  );
  static const VerificationMeta _cachedMeta = const VerificationMeta('cached');
  @override
  late final GeneratedColumn<bool> cached = GeneratedColumn<bool>(
    'cached',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("cached" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _promptCharsMeta = const VerificationMeta(
    'promptChars',
  );
  @override
  late final GeneratedColumn<int> promptChars = GeneratedColumn<int>(
    'prompt_chars',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _responseCharsMeta = const VerificationMeta(
    'responseChars',
  );
  @override
  late final GeneratedColumn<int> responseChars = GeneratedColumn<int>(
    'response_chars',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _errorMeta = const VerificationMeta('error');
  @override
  late final GeneratedColumn<String> error = GeneratedColumn<String>(
    'error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    at,
    lane,
    model,
    ok,
    cached,
    durationMs,
    promptChars,
    responseChars,
    error,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_calls';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiCallRow> instance, {
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
    if (data.containsKey('lane')) {
      context.handle(
        _laneMeta,
        lane.isAcceptableOrUnknown(data['lane']!, _laneMeta),
      );
    } else if (isInserting) {
      context.missing(_laneMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    } else if (isInserting) {
      context.missing(_modelMeta);
    }
    if (data.containsKey('ok')) {
      context.handle(_okMeta, ok.isAcceptableOrUnknown(data['ok']!, _okMeta));
    } else if (isInserting) {
      context.missing(_okMeta);
    }
    if (data.containsKey('cached')) {
      context.handle(
        _cachedMeta,
        cached.isAcceptableOrUnknown(data['cached']!, _cachedMeta),
      );
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    }
    if (data.containsKey('prompt_chars')) {
      context.handle(
        _promptCharsMeta,
        promptChars.isAcceptableOrUnknown(
          data['prompt_chars']!,
          _promptCharsMeta,
        ),
      );
    }
    if (data.containsKey('response_chars')) {
      context.handle(
        _responseCharsMeta,
        responseChars.isAcceptableOrUnknown(
          data['response_chars']!,
          _responseCharsMeta,
        ),
      );
    }
    if (data.containsKey('error')) {
      context.handle(
        _errorMeta,
        error.isAcceptableOrUnknown(data['error']!, _errorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AiCallRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiCallRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
      lane: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lane'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      )!,
      ok: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ok'],
      )!,
      cached: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}cached'],
      )!,
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      )!,
      promptChars: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prompt_chars'],
      )!,
      responseChars: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}response_chars'],
      )!,
      error: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error'],
      ),
    );
  }

  @override
  $AiCallsTable createAlias(String alias) {
    return $AiCallsTable(attachedDatabase, alias);
  }
}

class AiCallRow extends DataClass implements Insertable<AiCallRow> {
  final int id;
  final DateTime at;

  /// Which lane made it: `nutrition`, `trainer`, `embedding`.
  final String lane;
  final String model;
  final bool ok;

  /// Served from the cache without touching the network.
  final bool cached;
  final int durationMs;
  final int promptChars;
  final int responseChars;
  final String? error;
  const AiCallRow({
    required this.id,
    required this.at,
    required this.lane,
    required this.model,
    required this.ok,
    required this.cached,
    required this.durationMs,
    required this.promptChars,
    required this.responseChars,
    this.error,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['at'] = Variable<DateTime>(at);
    map['lane'] = Variable<String>(lane);
    map['model'] = Variable<String>(model);
    map['ok'] = Variable<bool>(ok);
    map['cached'] = Variable<bool>(cached);
    map['duration_ms'] = Variable<int>(durationMs);
    map['prompt_chars'] = Variable<int>(promptChars);
    map['response_chars'] = Variable<int>(responseChars);
    if (!nullToAbsent || error != null) {
      map['error'] = Variable<String>(error);
    }
    return map;
  }

  AiCallsCompanion toCompanion(bool nullToAbsent) {
    return AiCallsCompanion(
      id: Value(id),
      at: Value(at),
      lane: Value(lane),
      model: Value(model),
      ok: Value(ok),
      cached: Value(cached),
      durationMs: Value(durationMs),
      promptChars: Value(promptChars),
      responseChars: Value(responseChars),
      error: error == null && nullToAbsent
          ? const Value.absent()
          : Value(error),
    );
  }

  factory AiCallRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiCallRow(
      id: serializer.fromJson<int>(json['id']),
      at: serializer.fromJson<DateTime>(json['at']),
      lane: serializer.fromJson<String>(json['lane']),
      model: serializer.fromJson<String>(json['model']),
      ok: serializer.fromJson<bool>(json['ok']),
      cached: serializer.fromJson<bool>(json['cached']),
      durationMs: serializer.fromJson<int>(json['durationMs']),
      promptChars: serializer.fromJson<int>(json['promptChars']),
      responseChars: serializer.fromJson<int>(json['responseChars']),
      error: serializer.fromJson<String?>(json['error']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'at': serializer.toJson<DateTime>(at),
      'lane': serializer.toJson<String>(lane),
      'model': serializer.toJson<String>(model),
      'ok': serializer.toJson<bool>(ok),
      'cached': serializer.toJson<bool>(cached),
      'durationMs': serializer.toJson<int>(durationMs),
      'promptChars': serializer.toJson<int>(promptChars),
      'responseChars': serializer.toJson<int>(responseChars),
      'error': serializer.toJson<String?>(error),
    };
  }

  AiCallRow copyWith({
    int? id,
    DateTime? at,
    String? lane,
    String? model,
    bool? ok,
    bool? cached,
    int? durationMs,
    int? promptChars,
    int? responseChars,
    Value<String?> error = const Value.absent(),
  }) => AiCallRow(
    id: id ?? this.id,
    at: at ?? this.at,
    lane: lane ?? this.lane,
    model: model ?? this.model,
    ok: ok ?? this.ok,
    cached: cached ?? this.cached,
    durationMs: durationMs ?? this.durationMs,
    promptChars: promptChars ?? this.promptChars,
    responseChars: responseChars ?? this.responseChars,
    error: error.present ? error.value : this.error,
  );
  AiCallRow copyWithCompanion(AiCallsCompanion data) {
    return AiCallRow(
      id: data.id.present ? data.id.value : this.id,
      at: data.at.present ? data.at.value : this.at,
      lane: data.lane.present ? data.lane.value : this.lane,
      model: data.model.present ? data.model.value : this.model,
      ok: data.ok.present ? data.ok.value : this.ok,
      cached: data.cached.present ? data.cached.value : this.cached,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      promptChars: data.promptChars.present
          ? data.promptChars.value
          : this.promptChars,
      responseChars: data.responseChars.present
          ? data.responseChars.value
          : this.responseChars,
      error: data.error.present ? data.error.value : this.error,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiCallRow(')
          ..write('id: $id, ')
          ..write('at: $at, ')
          ..write('lane: $lane, ')
          ..write('model: $model, ')
          ..write('ok: $ok, ')
          ..write('cached: $cached, ')
          ..write('durationMs: $durationMs, ')
          ..write('promptChars: $promptChars, ')
          ..write('responseChars: $responseChars, ')
          ..write('error: $error')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    at,
    lane,
    model,
    ok,
    cached,
    durationMs,
    promptChars,
    responseChars,
    error,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiCallRow &&
          other.id == this.id &&
          other.at == this.at &&
          other.lane == this.lane &&
          other.model == this.model &&
          other.ok == this.ok &&
          other.cached == this.cached &&
          other.durationMs == this.durationMs &&
          other.promptChars == this.promptChars &&
          other.responseChars == this.responseChars &&
          other.error == this.error);
}

class AiCallsCompanion extends UpdateCompanion<AiCallRow> {
  final Value<int> id;
  final Value<DateTime> at;
  final Value<String> lane;
  final Value<String> model;
  final Value<bool> ok;
  final Value<bool> cached;
  final Value<int> durationMs;
  final Value<int> promptChars;
  final Value<int> responseChars;
  final Value<String?> error;
  const AiCallsCompanion({
    this.id = const Value.absent(),
    this.at = const Value.absent(),
    this.lane = const Value.absent(),
    this.model = const Value.absent(),
    this.ok = const Value.absent(),
    this.cached = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.promptChars = const Value.absent(),
    this.responseChars = const Value.absent(),
    this.error = const Value.absent(),
  });
  AiCallsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime at,
    required String lane,
    required String model,
    required bool ok,
    this.cached = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.promptChars = const Value.absent(),
    this.responseChars = const Value.absent(),
    this.error = const Value.absent(),
  }) : at = Value(at),
       lane = Value(lane),
       model = Value(model),
       ok = Value(ok);
  static Insertable<AiCallRow> custom({
    Expression<int>? id,
    Expression<DateTime>? at,
    Expression<String>? lane,
    Expression<String>? model,
    Expression<bool>? ok,
    Expression<bool>? cached,
    Expression<int>? durationMs,
    Expression<int>? promptChars,
    Expression<int>? responseChars,
    Expression<String>? error,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (at != null) 'at': at,
      if (lane != null) 'lane': lane,
      if (model != null) 'model': model,
      if (ok != null) 'ok': ok,
      if (cached != null) 'cached': cached,
      if (durationMs != null) 'duration_ms': durationMs,
      if (promptChars != null) 'prompt_chars': promptChars,
      if (responseChars != null) 'response_chars': responseChars,
      if (error != null) 'error': error,
    });
  }

  AiCallsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? at,
    Value<String>? lane,
    Value<String>? model,
    Value<bool>? ok,
    Value<bool>? cached,
    Value<int>? durationMs,
    Value<int>? promptChars,
    Value<int>? responseChars,
    Value<String?>? error,
  }) {
    return AiCallsCompanion(
      id: id ?? this.id,
      at: at ?? this.at,
      lane: lane ?? this.lane,
      model: model ?? this.model,
      ok: ok ?? this.ok,
      cached: cached ?? this.cached,
      durationMs: durationMs ?? this.durationMs,
      promptChars: promptChars ?? this.promptChars,
      responseChars: responseChars ?? this.responseChars,
      error: error ?? this.error,
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
    if (lane.present) {
      map['lane'] = Variable<String>(lane.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (ok.present) {
      map['ok'] = Variable<bool>(ok.value);
    }
    if (cached.present) {
      map['cached'] = Variable<bool>(cached.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (promptChars.present) {
      map['prompt_chars'] = Variable<int>(promptChars.value);
    }
    if (responseChars.present) {
      map['response_chars'] = Variable<int>(responseChars.value);
    }
    if (error.present) {
      map['error'] = Variable<String>(error.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiCallsCompanion(')
          ..write('id: $id, ')
          ..write('at: $at, ')
          ..write('lane: $lane, ')
          ..write('model: $model, ')
          ..write('ok: $ok, ')
          ..write('cached: $cached, ')
          ..write('durationMs: $durationMs, ')
          ..write('promptChars: $promptChars, ')
          ..write('responseChars: $responseChars, ')
          ..write('error: $error')
          ..write(')'))
        .toString();
  }
}

class $AiCacheEntriesTable extends AiCacheEntries
    with TableInfo<$AiCacheEntriesTable, AiCacheRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiCacheEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cacheKeyMeta = const VerificationMeta(
    'cacheKey',
  );
  @override
  late final GeneratedColumn<String> cacheKey = GeneratedColumn<String>(
    'cache_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _laneMeta = const VerificationMeta('lane');
  @override
  late final GeneratedColumn<String> lane = GeneratedColumn<String>(
    'lane',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _responseMeta = const VerificationMeta(
    'response',
  );
  @override
  late final GeneratedColumn<String> response = GeneratedColumn<String>(
    'response',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  List<GeneratedColumn> get $columns => [cacheKey, lane, response, at];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_cache_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiCacheRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cache_key')) {
      context.handle(
        _cacheKeyMeta,
        cacheKey.isAcceptableOrUnknown(data['cache_key']!, _cacheKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_cacheKeyMeta);
    }
    if (data.containsKey('lane')) {
      context.handle(
        _laneMeta,
        lane.isAcceptableOrUnknown(data['lane']!, _laneMeta),
      );
    } else if (isInserting) {
      context.missing(_laneMeta);
    }
    if (data.containsKey('response')) {
      context.handle(
        _responseMeta,
        response.isAcceptableOrUnknown(data['response']!, _responseMeta),
      );
    } else if (isInserting) {
      context.missing(_responseMeta);
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cacheKey};
  @override
  AiCacheRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiCacheRow(
      cacheKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cache_key'],
      )!,
      lane: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lane'],
      )!,
      response: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}response'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
    );
  }

  @override
  $AiCacheEntriesTable createAlias(String alias) {
    return $AiCacheEntriesTable(attachedDatabase, alias);
  }
}

class AiCacheRow extends DataClass implements Insertable<AiCacheRow> {
  final String cacheKey;
  final String lane;
  final String response;
  final DateTime at;
  const AiCacheRow({
    required this.cacheKey,
    required this.lane,
    required this.response,
    required this.at,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cache_key'] = Variable<String>(cacheKey);
    map['lane'] = Variable<String>(lane);
    map['response'] = Variable<String>(response);
    map['at'] = Variable<DateTime>(at);
    return map;
  }

  AiCacheEntriesCompanion toCompanion(bool nullToAbsent) {
    return AiCacheEntriesCompanion(
      cacheKey: Value(cacheKey),
      lane: Value(lane),
      response: Value(response),
      at: Value(at),
    );
  }

  factory AiCacheRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiCacheRow(
      cacheKey: serializer.fromJson<String>(json['cacheKey']),
      lane: serializer.fromJson<String>(json['lane']),
      response: serializer.fromJson<String>(json['response']),
      at: serializer.fromJson<DateTime>(json['at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cacheKey': serializer.toJson<String>(cacheKey),
      'lane': serializer.toJson<String>(lane),
      'response': serializer.toJson<String>(response),
      'at': serializer.toJson<DateTime>(at),
    };
  }

  AiCacheRow copyWith({
    String? cacheKey,
    String? lane,
    String? response,
    DateTime? at,
  }) => AiCacheRow(
    cacheKey: cacheKey ?? this.cacheKey,
    lane: lane ?? this.lane,
    response: response ?? this.response,
    at: at ?? this.at,
  );
  AiCacheRow copyWithCompanion(AiCacheEntriesCompanion data) {
    return AiCacheRow(
      cacheKey: data.cacheKey.present ? data.cacheKey.value : this.cacheKey,
      lane: data.lane.present ? data.lane.value : this.lane,
      response: data.response.present ? data.response.value : this.response,
      at: data.at.present ? data.at.value : this.at,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiCacheRow(')
          ..write('cacheKey: $cacheKey, ')
          ..write('lane: $lane, ')
          ..write('response: $response, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(cacheKey, lane, response, at);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiCacheRow &&
          other.cacheKey == this.cacheKey &&
          other.lane == this.lane &&
          other.response == this.response &&
          other.at == this.at);
}

class AiCacheEntriesCompanion extends UpdateCompanion<AiCacheRow> {
  final Value<String> cacheKey;
  final Value<String> lane;
  final Value<String> response;
  final Value<DateTime> at;
  final Value<int> rowid;
  const AiCacheEntriesCompanion({
    this.cacheKey = const Value.absent(),
    this.lane = const Value.absent(),
    this.response = const Value.absent(),
    this.at = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AiCacheEntriesCompanion.insert({
    required String cacheKey,
    required String lane,
    required String response,
    required DateTime at,
    this.rowid = const Value.absent(),
  }) : cacheKey = Value(cacheKey),
       lane = Value(lane),
       response = Value(response),
       at = Value(at);
  static Insertable<AiCacheRow> custom({
    Expression<String>? cacheKey,
    Expression<String>? lane,
    Expression<String>? response,
    Expression<DateTime>? at,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (cacheKey != null) 'cache_key': cacheKey,
      if (lane != null) 'lane': lane,
      if (response != null) 'response': response,
      if (at != null) 'at': at,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AiCacheEntriesCompanion copyWith({
    Value<String>? cacheKey,
    Value<String>? lane,
    Value<String>? response,
    Value<DateTime>? at,
    Value<int>? rowid,
  }) {
    return AiCacheEntriesCompanion(
      cacheKey: cacheKey ?? this.cacheKey,
      lane: lane ?? this.lane,
      response: response ?? this.response,
      at: at ?? this.at,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cacheKey.present) {
      map['cache_key'] = Variable<String>(cacheKey.value);
    }
    if (lane.present) {
      map['lane'] = Variable<String>(lane.value);
    }
    if (response.present) {
      map['response'] = Variable<String>(response.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiCacheEntriesCompanion(')
          ..write('cacheKey: $cacheKey, ')
          ..write('lane: $lane, ')
          ..write('response: $response, ')
          ..write('at: $at, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BodyMeasurementsTable extends BodyMeasurements
    with TableInfo<$BodyMeasurementsTable, BodyMeasurementRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BodyMeasurementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<int> day = GeneratedColumn<int>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _atMinutesMeta = const VerificationMeta(
    'atMinutes',
  );
  @override
  late final GeneratedColumn<int> atMinutes = GeneratedColumn<int>(
    'at_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
    'height_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bmiMeta = const VerificationMeta('bmi');
  @override
  late final GeneratedColumn<double> bmi = GeneratedColumn<double>(
    'bmi',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyFatPercentMeta = const VerificationMeta(
    'bodyFatPercent',
  );
  @override
  late final GeneratedColumn<double> bodyFatPercent = GeneratedColumn<double>(
    'body_fat_percent',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fatMassKgMeta = const VerificationMeta(
    'fatMassKg',
  );
  @override
  late final GeneratedColumn<double> fatMassKg = GeneratedColumn<double>(
    'fat_mass_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fatFreeMassKgMeta = const VerificationMeta(
    'fatFreeMassKg',
  );
  @override
  late final GeneratedColumn<double> fatFreeMassKg = GeneratedColumn<double>(
    'fat_free_mass_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _muscleMassKgMeta = const VerificationMeta(
    'muscleMassKg',
  );
  @override
  late final GeneratedColumn<double> muscleMassKg = GeneratedColumn<double>(
    'muscle_mass_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _skeletalMuscleKgMeta = const VerificationMeta(
    'skeletalMuscleKg',
  );
  @override
  late final GeneratedColumn<double> skeletalMuscleKg = GeneratedColumn<double>(
    'skeletal_muscle_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _skeletalMusclePercentMeta =
      const VerificationMeta('skeletalMusclePercent');
  @override
  late final GeneratedColumn<double> skeletalMusclePercent =
      GeneratedColumn<double>(
        'skeletal_muscle_percent',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _boneMassKgMeta = const VerificationMeta(
    'boneMassKg',
  );
  @override
  late final GeneratedColumn<double> boneMassKg = GeneratedColumn<double>(
    'bone_mass_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _proteinKgMeta = const VerificationMeta(
    'proteinKg',
  );
  @override
  late final GeneratedColumn<double> proteinKg = GeneratedColumn<double>(
    'protein_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _visceralFatMeta = const VerificationMeta(
    'visceralFat',
  );
  @override
  late final GeneratedColumn<int> visceralFat = GeneratedColumn<int>(
    'visceral_fat',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalBodyWaterKgMeta = const VerificationMeta(
    'totalBodyWaterKg',
  );
  @override
  late final GeneratedColumn<double> totalBodyWaterKg = GeneratedColumn<double>(
    'total_body_water_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalBodyWaterPercentMeta =
      const VerificationMeta('totalBodyWaterPercent');
  @override
  late final GeneratedColumn<double> totalBodyWaterPercent =
      GeneratedColumn<double>(
        'total_body_water_percent',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _extracellularWaterKgMeta =
      const VerificationMeta('extracellularWaterKg');
  @override
  late final GeneratedColumn<double> extracellularWaterKg =
      GeneratedColumn<double>(
        'extracellular_water_kg',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _intracellularWaterKgMeta =
      const VerificationMeta('intracellularWaterKg');
  @override
  late final GeneratedColumn<double> intracellularWaterKg =
      GeneratedColumn<double>(
        'intracellular_water_kg',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _ecwOverTbwPercentMeta = const VerificationMeta(
    'ecwOverTbwPercent',
  );
  @override
  late final GeneratedColumn<double> ecwOverTbwPercent =
      GeneratedColumn<double>(
        'ecw_over_tbw_percent',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _bmrKcalMeta = const VerificationMeta(
    'bmrKcal',
  );
  @override
  late final GeneratedColumn<int> bmrKcal = GeneratedColumn<int>(
    'bmr_kcal',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bmrKjMeta = const VerificationMeta('bmrKj');
  @override
  late final GeneratedColumn<int> bmrKj = GeneratedColumn<int>(
    'bmr_kj',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _metabolicAgeMeta = const VerificationMeta(
    'metabolicAge',
  );
  @override
  late final GeneratedColumn<int> metabolicAge = GeneratedColumn<int>(
    'metabolic_age',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sarcopenicIndexMeta = const VerificationMeta(
    'sarcopenicIndex',
  );
  @override
  late final GeneratedColumn<double> sarcopenicIndex = GeneratedColumn<double>(
    'sarcopenic_index',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phaseAngleDegMeta = const VerificationMeta(
    'phaseAngleDeg',
  );
  @override
  late final GeneratedColumn<double> phaseAngleDeg = GeneratedColumn<double>(
    'phase_angle_deg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _impedanceOhmMeta = const VerificationMeta(
    'impedanceOhm',
  );
  @override
  late final GeneratedColumn<int> impedanceOhm = GeneratedColumn<int>(
    'impedance_ohm',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    day,
    atMinutes,
    weightKg,
    heightCm,
    bmi,
    bodyFatPercent,
    fatMassKg,
    fatFreeMassKg,
    muscleMassKg,
    skeletalMuscleKg,
    skeletalMusclePercent,
    boneMassKg,
    proteinKg,
    visceralFat,
    totalBodyWaterKg,
    totalBodyWaterPercent,
    extracellularWaterKg,
    intracellularWaterKg,
    ecwOverTbwPercent,
    bmrKcal,
    bmrKj,
    metabolicAge,
    sarcopenicIndex,
    phaseAngleDeg,
    impedanceOhm,
    source,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'body_measurements';
  @override
  VerificationContext validateIntegrity(
    Insertable<BodyMeasurementRow> instance, {
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
    if (data.containsKey('at_minutes')) {
      context.handle(
        _atMinutesMeta,
        atMinutes.isAcceptableOrUnknown(data['at_minutes']!, _atMinutesMeta),
      );
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('height_cm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta),
      );
    }
    if (data.containsKey('bmi')) {
      context.handle(
        _bmiMeta,
        bmi.isAcceptableOrUnknown(data['bmi']!, _bmiMeta),
      );
    }
    if (data.containsKey('body_fat_percent')) {
      context.handle(
        _bodyFatPercentMeta,
        bodyFatPercent.isAcceptableOrUnknown(
          data['body_fat_percent']!,
          _bodyFatPercentMeta,
        ),
      );
    }
    if (data.containsKey('fat_mass_kg')) {
      context.handle(
        _fatMassKgMeta,
        fatMassKg.isAcceptableOrUnknown(data['fat_mass_kg']!, _fatMassKgMeta),
      );
    }
    if (data.containsKey('fat_free_mass_kg')) {
      context.handle(
        _fatFreeMassKgMeta,
        fatFreeMassKg.isAcceptableOrUnknown(
          data['fat_free_mass_kg']!,
          _fatFreeMassKgMeta,
        ),
      );
    }
    if (data.containsKey('muscle_mass_kg')) {
      context.handle(
        _muscleMassKgMeta,
        muscleMassKg.isAcceptableOrUnknown(
          data['muscle_mass_kg']!,
          _muscleMassKgMeta,
        ),
      );
    }
    if (data.containsKey('skeletal_muscle_kg')) {
      context.handle(
        _skeletalMuscleKgMeta,
        skeletalMuscleKg.isAcceptableOrUnknown(
          data['skeletal_muscle_kg']!,
          _skeletalMuscleKgMeta,
        ),
      );
    }
    if (data.containsKey('skeletal_muscle_percent')) {
      context.handle(
        _skeletalMusclePercentMeta,
        skeletalMusclePercent.isAcceptableOrUnknown(
          data['skeletal_muscle_percent']!,
          _skeletalMusclePercentMeta,
        ),
      );
    }
    if (data.containsKey('bone_mass_kg')) {
      context.handle(
        _boneMassKgMeta,
        boneMassKg.isAcceptableOrUnknown(
          data['bone_mass_kg']!,
          _boneMassKgMeta,
        ),
      );
    }
    if (data.containsKey('protein_kg')) {
      context.handle(
        _proteinKgMeta,
        proteinKg.isAcceptableOrUnknown(data['protein_kg']!, _proteinKgMeta),
      );
    }
    if (data.containsKey('visceral_fat')) {
      context.handle(
        _visceralFatMeta,
        visceralFat.isAcceptableOrUnknown(
          data['visceral_fat']!,
          _visceralFatMeta,
        ),
      );
    }
    if (data.containsKey('total_body_water_kg')) {
      context.handle(
        _totalBodyWaterKgMeta,
        totalBodyWaterKg.isAcceptableOrUnknown(
          data['total_body_water_kg']!,
          _totalBodyWaterKgMeta,
        ),
      );
    }
    if (data.containsKey('total_body_water_percent')) {
      context.handle(
        _totalBodyWaterPercentMeta,
        totalBodyWaterPercent.isAcceptableOrUnknown(
          data['total_body_water_percent']!,
          _totalBodyWaterPercentMeta,
        ),
      );
    }
    if (data.containsKey('extracellular_water_kg')) {
      context.handle(
        _extracellularWaterKgMeta,
        extracellularWaterKg.isAcceptableOrUnknown(
          data['extracellular_water_kg']!,
          _extracellularWaterKgMeta,
        ),
      );
    }
    if (data.containsKey('intracellular_water_kg')) {
      context.handle(
        _intracellularWaterKgMeta,
        intracellularWaterKg.isAcceptableOrUnknown(
          data['intracellular_water_kg']!,
          _intracellularWaterKgMeta,
        ),
      );
    }
    if (data.containsKey('ecw_over_tbw_percent')) {
      context.handle(
        _ecwOverTbwPercentMeta,
        ecwOverTbwPercent.isAcceptableOrUnknown(
          data['ecw_over_tbw_percent']!,
          _ecwOverTbwPercentMeta,
        ),
      );
    }
    if (data.containsKey('bmr_kcal')) {
      context.handle(
        _bmrKcalMeta,
        bmrKcal.isAcceptableOrUnknown(data['bmr_kcal']!, _bmrKcalMeta),
      );
    }
    if (data.containsKey('bmr_kj')) {
      context.handle(
        _bmrKjMeta,
        bmrKj.isAcceptableOrUnknown(data['bmr_kj']!, _bmrKjMeta),
      );
    }
    if (data.containsKey('metabolic_age')) {
      context.handle(
        _metabolicAgeMeta,
        metabolicAge.isAcceptableOrUnknown(
          data['metabolic_age']!,
          _metabolicAgeMeta,
        ),
      );
    }
    if (data.containsKey('sarcopenic_index')) {
      context.handle(
        _sarcopenicIndexMeta,
        sarcopenicIndex.isAcceptableOrUnknown(
          data['sarcopenic_index']!,
          _sarcopenicIndexMeta,
        ),
      );
    }
    if (data.containsKey('phase_angle_deg')) {
      context.handle(
        _phaseAngleDegMeta,
        phaseAngleDeg.isAcceptableOrUnknown(
          data['phase_angle_deg']!,
          _phaseAngleDegMeta,
        ),
      );
    }
    if (data.containsKey('impedance_ohm')) {
      context.handle(
        _impedanceOhmMeta,
        impedanceOhm.isAcceptableOrUnknown(
          data['impedance_ohm']!,
          _impedanceOhmMeta,
        ),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {day};
  @override
  BodyMeasurementRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BodyMeasurementRow(
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day'],
      )!,
      atMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}at_minutes'],
      ),
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      heightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height_cm'],
      ),
      bmi: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bmi'],
      ),
      bodyFatPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}body_fat_percent'],
      ),
      fatMassKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_mass_kg'],
      ),
      fatFreeMassKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_free_mass_kg'],
      ),
      muscleMassKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}muscle_mass_kg'],
      ),
      skeletalMuscleKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}skeletal_muscle_kg'],
      ),
      skeletalMusclePercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}skeletal_muscle_percent'],
      ),
      boneMassKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bone_mass_kg'],
      ),
      proteinKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_kg'],
      ),
      visceralFat: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}visceral_fat'],
      ),
      totalBodyWaterKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_body_water_kg'],
      ),
      totalBodyWaterPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_body_water_percent'],
      ),
      extracellularWaterKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}extracellular_water_kg'],
      ),
      intracellularWaterKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}intracellular_water_kg'],
      ),
      ecwOverTbwPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ecw_over_tbw_percent'],
      ),
      bmrKcal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bmr_kcal'],
      ),
      bmrKj: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bmr_kj'],
      ),
      metabolicAge: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}metabolic_age'],
      ),
      sarcopenicIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sarcopenic_index'],
      ),
      phaseAngleDeg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}phase_angle_deg'],
      ),
      impedanceOhm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}impedance_ohm'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $BodyMeasurementsTable createAlias(String alias) {
    return $BodyMeasurementsTable(attachedDatabase, alias);
  }
}

class BodyMeasurementRow extends DataClass
    implements Insertable<BodyMeasurementRow> {
  final int day;

  /// Minutes after midnight the scan was taken. Body water swings across a
  /// day, so two scans at different hours are not quite comparable and the
  /// time is part of the reading rather than trivia.
  final int? atMinutes;
  final double weightKg;
  final double? heightCm;
  final double? bmi;
  final double? bodyFatPercent;
  final double? fatMassKg;
  final double? fatFreeMassKg;
  final double? muscleMassKg;

  /// Skeletal muscle only — a subset of muscle mass, and the one the
  /// sarcopenic index is built from. Not interchangeable with it.
  final double? skeletalMuscleKg;
  final double? skeletalMusclePercent;
  final double? boneMassKg;
  final double? proteinKg;

  /// Tanita's visceral fat RATING — a 1-59 index, not kilograms or a percent.
  final int? visceralFat;
  final double? totalBodyWaterKg;
  final double? totalBodyWaterPercent;
  final double? extracellularWaterKg;
  final double? intracellularWaterKg;
  final double? ecwOverTbwPercent;
  final int? bmrKcal;
  final int? bmrKj;
  final int? metabolicAge;

  /// Sarcopenic index, kg/m². Skeletal muscle scaled to height.
  final double? sarcopenicIndex;

  /// Phase angle in degrees at 50 kHz, and whole-body impedance in ohms.
  final double? phaseAngleDeg;
  final int? impedanceOhm;

  /// Where it came from: 'Tanita MC-780', 'bathroom scale', and so on.
  final String source;
  final String? note;
  const BodyMeasurementRow({
    required this.day,
    this.atMinutes,
    required this.weightKg,
    this.heightCm,
    this.bmi,
    this.bodyFatPercent,
    this.fatMassKg,
    this.fatFreeMassKg,
    this.muscleMassKg,
    this.skeletalMuscleKg,
    this.skeletalMusclePercent,
    this.boneMassKg,
    this.proteinKg,
    this.visceralFat,
    this.totalBodyWaterKg,
    this.totalBodyWaterPercent,
    this.extracellularWaterKg,
    this.intracellularWaterKg,
    this.ecwOverTbwPercent,
    this.bmrKcal,
    this.bmrKj,
    this.metabolicAge,
    this.sarcopenicIndex,
    this.phaseAngleDeg,
    this.impedanceOhm,
    required this.source,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['day'] = Variable<int>(day);
    if (!nullToAbsent || atMinutes != null) {
      map['at_minutes'] = Variable<int>(atMinutes);
    }
    map['weight_kg'] = Variable<double>(weightKg);
    if (!nullToAbsent || heightCm != null) {
      map['height_cm'] = Variable<double>(heightCm);
    }
    if (!nullToAbsent || bmi != null) {
      map['bmi'] = Variable<double>(bmi);
    }
    if (!nullToAbsent || bodyFatPercent != null) {
      map['body_fat_percent'] = Variable<double>(bodyFatPercent);
    }
    if (!nullToAbsent || fatMassKg != null) {
      map['fat_mass_kg'] = Variable<double>(fatMassKg);
    }
    if (!nullToAbsent || fatFreeMassKg != null) {
      map['fat_free_mass_kg'] = Variable<double>(fatFreeMassKg);
    }
    if (!nullToAbsent || muscleMassKg != null) {
      map['muscle_mass_kg'] = Variable<double>(muscleMassKg);
    }
    if (!nullToAbsent || skeletalMuscleKg != null) {
      map['skeletal_muscle_kg'] = Variable<double>(skeletalMuscleKg);
    }
    if (!nullToAbsent || skeletalMusclePercent != null) {
      map['skeletal_muscle_percent'] = Variable<double>(skeletalMusclePercent);
    }
    if (!nullToAbsent || boneMassKg != null) {
      map['bone_mass_kg'] = Variable<double>(boneMassKg);
    }
    if (!nullToAbsent || proteinKg != null) {
      map['protein_kg'] = Variable<double>(proteinKg);
    }
    if (!nullToAbsent || visceralFat != null) {
      map['visceral_fat'] = Variable<int>(visceralFat);
    }
    if (!nullToAbsent || totalBodyWaterKg != null) {
      map['total_body_water_kg'] = Variable<double>(totalBodyWaterKg);
    }
    if (!nullToAbsent || totalBodyWaterPercent != null) {
      map['total_body_water_percent'] = Variable<double>(totalBodyWaterPercent);
    }
    if (!nullToAbsent || extracellularWaterKg != null) {
      map['extracellular_water_kg'] = Variable<double>(extracellularWaterKg);
    }
    if (!nullToAbsent || intracellularWaterKg != null) {
      map['intracellular_water_kg'] = Variable<double>(intracellularWaterKg);
    }
    if (!nullToAbsent || ecwOverTbwPercent != null) {
      map['ecw_over_tbw_percent'] = Variable<double>(ecwOverTbwPercent);
    }
    if (!nullToAbsent || bmrKcal != null) {
      map['bmr_kcal'] = Variable<int>(bmrKcal);
    }
    if (!nullToAbsent || bmrKj != null) {
      map['bmr_kj'] = Variable<int>(bmrKj);
    }
    if (!nullToAbsent || metabolicAge != null) {
      map['metabolic_age'] = Variable<int>(metabolicAge);
    }
    if (!nullToAbsent || sarcopenicIndex != null) {
      map['sarcopenic_index'] = Variable<double>(sarcopenicIndex);
    }
    if (!nullToAbsent || phaseAngleDeg != null) {
      map['phase_angle_deg'] = Variable<double>(phaseAngleDeg);
    }
    if (!nullToAbsent || impedanceOhm != null) {
      map['impedance_ohm'] = Variable<int>(impedanceOhm);
    }
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  BodyMeasurementsCompanion toCompanion(bool nullToAbsent) {
    return BodyMeasurementsCompanion(
      day: Value(day),
      atMinutes: atMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(atMinutes),
      weightKg: Value(weightKg),
      heightCm: heightCm == null && nullToAbsent
          ? const Value.absent()
          : Value(heightCm),
      bmi: bmi == null && nullToAbsent ? const Value.absent() : Value(bmi),
      bodyFatPercent: bodyFatPercent == null && nullToAbsent
          ? const Value.absent()
          : Value(bodyFatPercent),
      fatMassKg: fatMassKg == null && nullToAbsent
          ? const Value.absent()
          : Value(fatMassKg),
      fatFreeMassKg: fatFreeMassKg == null && nullToAbsent
          ? const Value.absent()
          : Value(fatFreeMassKg),
      muscleMassKg: muscleMassKg == null && nullToAbsent
          ? const Value.absent()
          : Value(muscleMassKg),
      skeletalMuscleKg: skeletalMuscleKg == null && nullToAbsent
          ? const Value.absent()
          : Value(skeletalMuscleKg),
      skeletalMusclePercent: skeletalMusclePercent == null && nullToAbsent
          ? const Value.absent()
          : Value(skeletalMusclePercent),
      boneMassKg: boneMassKg == null && nullToAbsent
          ? const Value.absent()
          : Value(boneMassKg),
      proteinKg: proteinKg == null && nullToAbsent
          ? const Value.absent()
          : Value(proteinKg),
      visceralFat: visceralFat == null && nullToAbsent
          ? const Value.absent()
          : Value(visceralFat),
      totalBodyWaterKg: totalBodyWaterKg == null && nullToAbsent
          ? const Value.absent()
          : Value(totalBodyWaterKg),
      totalBodyWaterPercent: totalBodyWaterPercent == null && nullToAbsent
          ? const Value.absent()
          : Value(totalBodyWaterPercent),
      extracellularWaterKg: extracellularWaterKg == null && nullToAbsent
          ? const Value.absent()
          : Value(extracellularWaterKg),
      intracellularWaterKg: intracellularWaterKg == null && nullToAbsent
          ? const Value.absent()
          : Value(intracellularWaterKg),
      ecwOverTbwPercent: ecwOverTbwPercent == null && nullToAbsent
          ? const Value.absent()
          : Value(ecwOverTbwPercent),
      bmrKcal: bmrKcal == null && nullToAbsent
          ? const Value.absent()
          : Value(bmrKcal),
      bmrKj: bmrKj == null && nullToAbsent
          ? const Value.absent()
          : Value(bmrKj),
      metabolicAge: metabolicAge == null && nullToAbsent
          ? const Value.absent()
          : Value(metabolicAge),
      sarcopenicIndex: sarcopenicIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(sarcopenicIndex),
      phaseAngleDeg: phaseAngleDeg == null && nullToAbsent
          ? const Value.absent()
          : Value(phaseAngleDeg),
      impedanceOhm: impedanceOhm == null && nullToAbsent
          ? const Value.absent()
          : Value(impedanceOhm),
      source: Value(source),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory BodyMeasurementRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BodyMeasurementRow(
      day: serializer.fromJson<int>(json['day']),
      atMinutes: serializer.fromJson<int?>(json['atMinutes']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      heightCm: serializer.fromJson<double?>(json['heightCm']),
      bmi: serializer.fromJson<double?>(json['bmi']),
      bodyFatPercent: serializer.fromJson<double?>(json['bodyFatPercent']),
      fatMassKg: serializer.fromJson<double?>(json['fatMassKg']),
      fatFreeMassKg: serializer.fromJson<double?>(json['fatFreeMassKg']),
      muscleMassKg: serializer.fromJson<double?>(json['muscleMassKg']),
      skeletalMuscleKg: serializer.fromJson<double?>(json['skeletalMuscleKg']),
      skeletalMusclePercent: serializer.fromJson<double?>(
        json['skeletalMusclePercent'],
      ),
      boneMassKg: serializer.fromJson<double?>(json['boneMassKg']),
      proteinKg: serializer.fromJson<double?>(json['proteinKg']),
      visceralFat: serializer.fromJson<int?>(json['visceralFat']),
      totalBodyWaterKg: serializer.fromJson<double?>(json['totalBodyWaterKg']),
      totalBodyWaterPercent: serializer.fromJson<double?>(
        json['totalBodyWaterPercent'],
      ),
      extracellularWaterKg: serializer.fromJson<double?>(
        json['extracellularWaterKg'],
      ),
      intracellularWaterKg: serializer.fromJson<double?>(
        json['intracellularWaterKg'],
      ),
      ecwOverTbwPercent: serializer.fromJson<double?>(
        json['ecwOverTbwPercent'],
      ),
      bmrKcal: serializer.fromJson<int?>(json['bmrKcal']),
      bmrKj: serializer.fromJson<int?>(json['bmrKj']),
      metabolicAge: serializer.fromJson<int?>(json['metabolicAge']),
      sarcopenicIndex: serializer.fromJson<double?>(json['sarcopenicIndex']),
      phaseAngleDeg: serializer.fromJson<double?>(json['phaseAngleDeg']),
      impedanceOhm: serializer.fromJson<int?>(json['impedanceOhm']),
      source: serializer.fromJson<String>(json['source']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'day': serializer.toJson<int>(day),
      'atMinutes': serializer.toJson<int?>(atMinutes),
      'weightKg': serializer.toJson<double>(weightKg),
      'heightCm': serializer.toJson<double?>(heightCm),
      'bmi': serializer.toJson<double?>(bmi),
      'bodyFatPercent': serializer.toJson<double?>(bodyFatPercent),
      'fatMassKg': serializer.toJson<double?>(fatMassKg),
      'fatFreeMassKg': serializer.toJson<double?>(fatFreeMassKg),
      'muscleMassKg': serializer.toJson<double?>(muscleMassKg),
      'skeletalMuscleKg': serializer.toJson<double?>(skeletalMuscleKg),
      'skeletalMusclePercent': serializer.toJson<double?>(
        skeletalMusclePercent,
      ),
      'boneMassKg': serializer.toJson<double?>(boneMassKg),
      'proteinKg': serializer.toJson<double?>(proteinKg),
      'visceralFat': serializer.toJson<int?>(visceralFat),
      'totalBodyWaterKg': serializer.toJson<double?>(totalBodyWaterKg),
      'totalBodyWaterPercent': serializer.toJson<double?>(
        totalBodyWaterPercent,
      ),
      'extracellularWaterKg': serializer.toJson<double?>(extracellularWaterKg),
      'intracellularWaterKg': serializer.toJson<double?>(intracellularWaterKg),
      'ecwOverTbwPercent': serializer.toJson<double?>(ecwOverTbwPercent),
      'bmrKcal': serializer.toJson<int?>(bmrKcal),
      'bmrKj': serializer.toJson<int?>(bmrKj),
      'metabolicAge': serializer.toJson<int?>(metabolicAge),
      'sarcopenicIndex': serializer.toJson<double?>(sarcopenicIndex),
      'phaseAngleDeg': serializer.toJson<double?>(phaseAngleDeg),
      'impedanceOhm': serializer.toJson<int?>(impedanceOhm),
      'source': serializer.toJson<String>(source),
      'note': serializer.toJson<String?>(note),
    };
  }

  BodyMeasurementRow copyWith({
    int? day,
    Value<int?> atMinutes = const Value.absent(),
    double? weightKg,
    Value<double?> heightCm = const Value.absent(),
    Value<double?> bmi = const Value.absent(),
    Value<double?> bodyFatPercent = const Value.absent(),
    Value<double?> fatMassKg = const Value.absent(),
    Value<double?> fatFreeMassKg = const Value.absent(),
    Value<double?> muscleMassKg = const Value.absent(),
    Value<double?> skeletalMuscleKg = const Value.absent(),
    Value<double?> skeletalMusclePercent = const Value.absent(),
    Value<double?> boneMassKg = const Value.absent(),
    Value<double?> proteinKg = const Value.absent(),
    Value<int?> visceralFat = const Value.absent(),
    Value<double?> totalBodyWaterKg = const Value.absent(),
    Value<double?> totalBodyWaterPercent = const Value.absent(),
    Value<double?> extracellularWaterKg = const Value.absent(),
    Value<double?> intracellularWaterKg = const Value.absent(),
    Value<double?> ecwOverTbwPercent = const Value.absent(),
    Value<int?> bmrKcal = const Value.absent(),
    Value<int?> bmrKj = const Value.absent(),
    Value<int?> metabolicAge = const Value.absent(),
    Value<double?> sarcopenicIndex = const Value.absent(),
    Value<double?> phaseAngleDeg = const Value.absent(),
    Value<int?> impedanceOhm = const Value.absent(),
    String? source,
    Value<String?> note = const Value.absent(),
  }) => BodyMeasurementRow(
    day: day ?? this.day,
    atMinutes: atMinutes.present ? atMinutes.value : this.atMinutes,
    weightKg: weightKg ?? this.weightKg,
    heightCm: heightCm.present ? heightCm.value : this.heightCm,
    bmi: bmi.present ? bmi.value : this.bmi,
    bodyFatPercent: bodyFatPercent.present
        ? bodyFatPercent.value
        : this.bodyFatPercent,
    fatMassKg: fatMassKg.present ? fatMassKg.value : this.fatMassKg,
    fatFreeMassKg: fatFreeMassKg.present
        ? fatFreeMassKg.value
        : this.fatFreeMassKg,
    muscleMassKg: muscleMassKg.present ? muscleMassKg.value : this.muscleMassKg,
    skeletalMuscleKg: skeletalMuscleKg.present
        ? skeletalMuscleKg.value
        : this.skeletalMuscleKg,
    skeletalMusclePercent: skeletalMusclePercent.present
        ? skeletalMusclePercent.value
        : this.skeletalMusclePercent,
    boneMassKg: boneMassKg.present ? boneMassKg.value : this.boneMassKg,
    proteinKg: proteinKg.present ? proteinKg.value : this.proteinKg,
    visceralFat: visceralFat.present ? visceralFat.value : this.visceralFat,
    totalBodyWaterKg: totalBodyWaterKg.present
        ? totalBodyWaterKg.value
        : this.totalBodyWaterKg,
    totalBodyWaterPercent: totalBodyWaterPercent.present
        ? totalBodyWaterPercent.value
        : this.totalBodyWaterPercent,
    extracellularWaterKg: extracellularWaterKg.present
        ? extracellularWaterKg.value
        : this.extracellularWaterKg,
    intracellularWaterKg: intracellularWaterKg.present
        ? intracellularWaterKg.value
        : this.intracellularWaterKg,
    ecwOverTbwPercent: ecwOverTbwPercent.present
        ? ecwOverTbwPercent.value
        : this.ecwOverTbwPercent,
    bmrKcal: bmrKcal.present ? bmrKcal.value : this.bmrKcal,
    bmrKj: bmrKj.present ? bmrKj.value : this.bmrKj,
    metabolicAge: metabolicAge.present ? metabolicAge.value : this.metabolicAge,
    sarcopenicIndex: sarcopenicIndex.present
        ? sarcopenicIndex.value
        : this.sarcopenicIndex,
    phaseAngleDeg: phaseAngleDeg.present
        ? phaseAngleDeg.value
        : this.phaseAngleDeg,
    impedanceOhm: impedanceOhm.present ? impedanceOhm.value : this.impedanceOhm,
    source: source ?? this.source,
    note: note.present ? note.value : this.note,
  );
  BodyMeasurementRow copyWithCompanion(BodyMeasurementsCompanion data) {
    return BodyMeasurementRow(
      day: data.day.present ? data.day.value : this.day,
      atMinutes: data.atMinutes.present ? data.atMinutes.value : this.atMinutes,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      bmi: data.bmi.present ? data.bmi.value : this.bmi,
      bodyFatPercent: data.bodyFatPercent.present
          ? data.bodyFatPercent.value
          : this.bodyFatPercent,
      fatMassKg: data.fatMassKg.present ? data.fatMassKg.value : this.fatMassKg,
      fatFreeMassKg: data.fatFreeMassKg.present
          ? data.fatFreeMassKg.value
          : this.fatFreeMassKg,
      muscleMassKg: data.muscleMassKg.present
          ? data.muscleMassKg.value
          : this.muscleMassKg,
      skeletalMuscleKg: data.skeletalMuscleKg.present
          ? data.skeletalMuscleKg.value
          : this.skeletalMuscleKg,
      skeletalMusclePercent: data.skeletalMusclePercent.present
          ? data.skeletalMusclePercent.value
          : this.skeletalMusclePercent,
      boneMassKg: data.boneMassKg.present
          ? data.boneMassKg.value
          : this.boneMassKg,
      proteinKg: data.proteinKg.present ? data.proteinKg.value : this.proteinKg,
      visceralFat: data.visceralFat.present
          ? data.visceralFat.value
          : this.visceralFat,
      totalBodyWaterKg: data.totalBodyWaterKg.present
          ? data.totalBodyWaterKg.value
          : this.totalBodyWaterKg,
      totalBodyWaterPercent: data.totalBodyWaterPercent.present
          ? data.totalBodyWaterPercent.value
          : this.totalBodyWaterPercent,
      extracellularWaterKg: data.extracellularWaterKg.present
          ? data.extracellularWaterKg.value
          : this.extracellularWaterKg,
      intracellularWaterKg: data.intracellularWaterKg.present
          ? data.intracellularWaterKg.value
          : this.intracellularWaterKg,
      ecwOverTbwPercent: data.ecwOverTbwPercent.present
          ? data.ecwOverTbwPercent.value
          : this.ecwOverTbwPercent,
      bmrKcal: data.bmrKcal.present ? data.bmrKcal.value : this.bmrKcal,
      bmrKj: data.bmrKj.present ? data.bmrKj.value : this.bmrKj,
      metabolicAge: data.metabolicAge.present
          ? data.metabolicAge.value
          : this.metabolicAge,
      sarcopenicIndex: data.sarcopenicIndex.present
          ? data.sarcopenicIndex.value
          : this.sarcopenicIndex,
      phaseAngleDeg: data.phaseAngleDeg.present
          ? data.phaseAngleDeg.value
          : this.phaseAngleDeg,
      impedanceOhm: data.impedanceOhm.present
          ? data.impedanceOhm.value
          : this.impedanceOhm,
      source: data.source.present ? data.source.value : this.source,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BodyMeasurementRow(')
          ..write('day: $day, ')
          ..write('atMinutes: $atMinutes, ')
          ..write('weightKg: $weightKg, ')
          ..write('heightCm: $heightCm, ')
          ..write('bmi: $bmi, ')
          ..write('bodyFatPercent: $bodyFatPercent, ')
          ..write('fatMassKg: $fatMassKg, ')
          ..write('fatFreeMassKg: $fatFreeMassKg, ')
          ..write('muscleMassKg: $muscleMassKg, ')
          ..write('skeletalMuscleKg: $skeletalMuscleKg, ')
          ..write('skeletalMusclePercent: $skeletalMusclePercent, ')
          ..write('boneMassKg: $boneMassKg, ')
          ..write('proteinKg: $proteinKg, ')
          ..write('visceralFat: $visceralFat, ')
          ..write('totalBodyWaterKg: $totalBodyWaterKg, ')
          ..write('totalBodyWaterPercent: $totalBodyWaterPercent, ')
          ..write('extracellularWaterKg: $extracellularWaterKg, ')
          ..write('intracellularWaterKg: $intracellularWaterKg, ')
          ..write('ecwOverTbwPercent: $ecwOverTbwPercent, ')
          ..write('bmrKcal: $bmrKcal, ')
          ..write('bmrKj: $bmrKj, ')
          ..write('metabolicAge: $metabolicAge, ')
          ..write('sarcopenicIndex: $sarcopenicIndex, ')
          ..write('phaseAngleDeg: $phaseAngleDeg, ')
          ..write('impedanceOhm: $impedanceOhm, ')
          ..write('source: $source, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    day,
    atMinutes,
    weightKg,
    heightCm,
    bmi,
    bodyFatPercent,
    fatMassKg,
    fatFreeMassKg,
    muscleMassKg,
    skeletalMuscleKg,
    skeletalMusclePercent,
    boneMassKg,
    proteinKg,
    visceralFat,
    totalBodyWaterKg,
    totalBodyWaterPercent,
    extracellularWaterKg,
    intracellularWaterKg,
    ecwOverTbwPercent,
    bmrKcal,
    bmrKj,
    metabolicAge,
    sarcopenicIndex,
    phaseAngleDeg,
    impedanceOhm,
    source,
    note,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BodyMeasurementRow &&
          other.day == this.day &&
          other.atMinutes == this.atMinutes &&
          other.weightKg == this.weightKg &&
          other.heightCm == this.heightCm &&
          other.bmi == this.bmi &&
          other.bodyFatPercent == this.bodyFatPercent &&
          other.fatMassKg == this.fatMassKg &&
          other.fatFreeMassKg == this.fatFreeMassKg &&
          other.muscleMassKg == this.muscleMassKg &&
          other.skeletalMuscleKg == this.skeletalMuscleKg &&
          other.skeletalMusclePercent == this.skeletalMusclePercent &&
          other.boneMassKg == this.boneMassKg &&
          other.proteinKg == this.proteinKg &&
          other.visceralFat == this.visceralFat &&
          other.totalBodyWaterKg == this.totalBodyWaterKg &&
          other.totalBodyWaterPercent == this.totalBodyWaterPercent &&
          other.extracellularWaterKg == this.extracellularWaterKg &&
          other.intracellularWaterKg == this.intracellularWaterKg &&
          other.ecwOverTbwPercent == this.ecwOverTbwPercent &&
          other.bmrKcal == this.bmrKcal &&
          other.bmrKj == this.bmrKj &&
          other.metabolicAge == this.metabolicAge &&
          other.sarcopenicIndex == this.sarcopenicIndex &&
          other.phaseAngleDeg == this.phaseAngleDeg &&
          other.impedanceOhm == this.impedanceOhm &&
          other.source == this.source &&
          other.note == this.note);
}

class BodyMeasurementsCompanion extends UpdateCompanion<BodyMeasurementRow> {
  final Value<int> day;
  final Value<int?> atMinutes;
  final Value<double> weightKg;
  final Value<double?> heightCm;
  final Value<double?> bmi;
  final Value<double?> bodyFatPercent;
  final Value<double?> fatMassKg;
  final Value<double?> fatFreeMassKg;
  final Value<double?> muscleMassKg;
  final Value<double?> skeletalMuscleKg;
  final Value<double?> skeletalMusclePercent;
  final Value<double?> boneMassKg;
  final Value<double?> proteinKg;
  final Value<int?> visceralFat;
  final Value<double?> totalBodyWaterKg;
  final Value<double?> totalBodyWaterPercent;
  final Value<double?> extracellularWaterKg;
  final Value<double?> intracellularWaterKg;
  final Value<double?> ecwOverTbwPercent;
  final Value<int?> bmrKcal;
  final Value<int?> bmrKj;
  final Value<int?> metabolicAge;
  final Value<double?> sarcopenicIndex;
  final Value<double?> phaseAngleDeg;
  final Value<int?> impedanceOhm;
  final Value<String> source;
  final Value<String?> note;
  const BodyMeasurementsCompanion({
    this.day = const Value.absent(),
    this.atMinutes = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.bmi = const Value.absent(),
    this.bodyFatPercent = const Value.absent(),
    this.fatMassKg = const Value.absent(),
    this.fatFreeMassKg = const Value.absent(),
    this.muscleMassKg = const Value.absent(),
    this.skeletalMuscleKg = const Value.absent(),
    this.skeletalMusclePercent = const Value.absent(),
    this.boneMassKg = const Value.absent(),
    this.proteinKg = const Value.absent(),
    this.visceralFat = const Value.absent(),
    this.totalBodyWaterKg = const Value.absent(),
    this.totalBodyWaterPercent = const Value.absent(),
    this.extracellularWaterKg = const Value.absent(),
    this.intracellularWaterKg = const Value.absent(),
    this.ecwOverTbwPercent = const Value.absent(),
    this.bmrKcal = const Value.absent(),
    this.bmrKj = const Value.absent(),
    this.metabolicAge = const Value.absent(),
    this.sarcopenicIndex = const Value.absent(),
    this.phaseAngleDeg = const Value.absent(),
    this.impedanceOhm = const Value.absent(),
    this.source = const Value.absent(),
    this.note = const Value.absent(),
  });
  BodyMeasurementsCompanion.insert({
    this.day = const Value.absent(),
    this.atMinutes = const Value.absent(),
    required double weightKg,
    this.heightCm = const Value.absent(),
    this.bmi = const Value.absent(),
    this.bodyFatPercent = const Value.absent(),
    this.fatMassKg = const Value.absent(),
    this.fatFreeMassKg = const Value.absent(),
    this.muscleMassKg = const Value.absent(),
    this.skeletalMuscleKg = const Value.absent(),
    this.skeletalMusclePercent = const Value.absent(),
    this.boneMassKg = const Value.absent(),
    this.proteinKg = const Value.absent(),
    this.visceralFat = const Value.absent(),
    this.totalBodyWaterKg = const Value.absent(),
    this.totalBodyWaterPercent = const Value.absent(),
    this.extracellularWaterKg = const Value.absent(),
    this.intracellularWaterKg = const Value.absent(),
    this.ecwOverTbwPercent = const Value.absent(),
    this.bmrKcal = const Value.absent(),
    this.bmrKj = const Value.absent(),
    this.metabolicAge = const Value.absent(),
    this.sarcopenicIndex = const Value.absent(),
    this.phaseAngleDeg = const Value.absent(),
    this.impedanceOhm = const Value.absent(),
    this.source = const Value.absent(),
    this.note = const Value.absent(),
  }) : weightKg = Value(weightKg);
  static Insertable<BodyMeasurementRow> custom({
    Expression<int>? day,
    Expression<int>? atMinutes,
    Expression<double>? weightKg,
    Expression<double>? heightCm,
    Expression<double>? bmi,
    Expression<double>? bodyFatPercent,
    Expression<double>? fatMassKg,
    Expression<double>? fatFreeMassKg,
    Expression<double>? muscleMassKg,
    Expression<double>? skeletalMuscleKg,
    Expression<double>? skeletalMusclePercent,
    Expression<double>? boneMassKg,
    Expression<double>? proteinKg,
    Expression<int>? visceralFat,
    Expression<double>? totalBodyWaterKg,
    Expression<double>? totalBodyWaterPercent,
    Expression<double>? extracellularWaterKg,
    Expression<double>? intracellularWaterKg,
    Expression<double>? ecwOverTbwPercent,
    Expression<int>? bmrKcal,
    Expression<int>? bmrKj,
    Expression<int>? metabolicAge,
    Expression<double>? sarcopenicIndex,
    Expression<double>? phaseAngleDeg,
    Expression<int>? impedanceOhm,
    Expression<String>? source,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (day != null) 'day': day,
      if (atMinutes != null) 'at_minutes': atMinutes,
      if (weightKg != null) 'weight_kg': weightKg,
      if (heightCm != null) 'height_cm': heightCm,
      if (bmi != null) 'bmi': bmi,
      if (bodyFatPercent != null) 'body_fat_percent': bodyFatPercent,
      if (fatMassKg != null) 'fat_mass_kg': fatMassKg,
      if (fatFreeMassKg != null) 'fat_free_mass_kg': fatFreeMassKg,
      if (muscleMassKg != null) 'muscle_mass_kg': muscleMassKg,
      if (skeletalMuscleKg != null) 'skeletal_muscle_kg': skeletalMuscleKg,
      if (skeletalMusclePercent != null)
        'skeletal_muscle_percent': skeletalMusclePercent,
      if (boneMassKg != null) 'bone_mass_kg': boneMassKg,
      if (proteinKg != null) 'protein_kg': proteinKg,
      if (visceralFat != null) 'visceral_fat': visceralFat,
      if (totalBodyWaterKg != null) 'total_body_water_kg': totalBodyWaterKg,
      if (totalBodyWaterPercent != null)
        'total_body_water_percent': totalBodyWaterPercent,
      if (extracellularWaterKg != null)
        'extracellular_water_kg': extracellularWaterKg,
      if (intracellularWaterKg != null)
        'intracellular_water_kg': intracellularWaterKg,
      if (ecwOverTbwPercent != null) 'ecw_over_tbw_percent': ecwOverTbwPercent,
      if (bmrKcal != null) 'bmr_kcal': bmrKcal,
      if (bmrKj != null) 'bmr_kj': bmrKj,
      if (metabolicAge != null) 'metabolic_age': metabolicAge,
      if (sarcopenicIndex != null) 'sarcopenic_index': sarcopenicIndex,
      if (phaseAngleDeg != null) 'phase_angle_deg': phaseAngleDeg,
      if (impedanceOhm != null) 'impedance_ohm': impedanceOhm,
      if (source != null) 'source': source,
      if (note != null) 'note': note,
    });
  }

  BodyMeasurementsCompanion copyWith({
    Value<int>? day,
    Value<int?>? atMinutes,
    Value<double>? weightKg,
    Value<double?>? heightCm,
    Value<double?>? bmi,
    Value<double?>? bodyFatPercent,
    Value<double?>? fatMassKg,
    Value<double?>? fatFreeMassKg,
    Value<double?>? muscleMassKg,
    Value<double?>? skeletalMuscleKg,
    Value<double?>? skeletalMusclePercent,
    Value<double?>? boneMassKg,
    Value<double?>? proteinKg,
    Value<int?>? visceralFat,
    Value<double?>? totalBodyWaterKg,
    Value<double?>? totalBodyWaterPercent,
    Value<double?>? extracellularWaterKg,
    Value<double?>? intracellularWaterKg,
    Value<double?>? ecwOverTbwPercent,
    Value<int?>? bmrKcal,
    Value<int?>? bmrKj,
    Value<int?>? metabolicAge,
    Value<double?>? sarcopenicIndex,
    Value<double?>? phaseAngleDeg,
    Value<int?>? impedanceOhm,
    Value<String>? source,
    Value<String?>? note,
  }) {
    return BodyMeasurementsCompanion(
      day: day ?? this.day,
      atMinutes: atMinutes ?? this.atMinutes,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      bmi: bmi ?? this.bmi,
      bodyFatPercent: bodyFatPercent ?? this.bodyFatPercent,
      fatMassKg: fatMassKg ?? this.fatMassKg,
      fatFreeMassKg: fatFreeMassKg ?? this.fatFreeMassKg,
      muscleMassKg: muscleMassKg ?? this.muscleMassKg,
      skeletalMuscleKg: skeletalMuscleKg ?? this.skeletalMuscleKg,
      skeletalMusclePercent:
          skeletalMusclePercent ?? this.skeletalMusclePercent,
      boneMassKg: boneMassKg ?? this.boneMassKg,
      proteinKg: proteinKg ?? this.proteinKg,
      visceralFat: visceralFat ?? this.visceralFat,
      totalBodyWaterKg: totalBodyWaterKg ?? this.totalBodyWaterKg,
      totalBodyWaterPercent:
          totalBodyWaterPercent ?? this.totalBodyWaterPercent,
      extracellularWaterKg: extracellularWaterKg ?? this.extracellularWaterKg,
      intracellularWaterKg: intracellularWaterKg ?? this.intracellularWaterKg,
      ecwOverTbwPercent: ecwOverTbwPercent ?? this.ecwOverTbwPercent,
      bmrKcal: bmrKcal ?? this.bmrKcal,
      bmrKj: bmrKj ?? this.bmrKj,
      metabolicAge: metabolicAge ?? this.metabolicAge,
      sarcopenicIndex: sarcopenicIndex ?? this.sarcopenicIndex,
      phaseAngleDeg: phaseAngleDeg ?? this.phaseAngleDeg,
      impedanceOhm: impedanceOhm ?? this.impedanceOhm,
      source: source ?? this.source,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (day.present) {
      map['day'] = Variable<int>(day.value);
    }
    if (atMinutes.present) {
      map['at_minutes'] = Variable<int>(atMinutes.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<double>(heightCm.value);
    }
    if (bmi.present) {
      map['bmi'] = Variable<double>(bmi.value);
    }
    if (bodyFatPercent.present) {
      map['body_fat_percent'] = Variable<double>(bodyFatPercent.value);
    }
    if (fatMassKg.present) {
      map['fat_mass_kg'] = Variable<double>(fatMassKg.value);
    }
    if (fatFreeMassKg.present) {
      map['fat_free_mass_kg'] = Variable<double>(fatFreeMassKg.value);
    }
    if (muscleMassKg.present) {
      map['muscle_mass_kg'] = Variable<double>(muscleMassKg.value);
    }
    if (skeletalMuscleKg.present) {
      map['skeletal_muscle_kg'] = Variable<double>(skeletalMuscleKg.value);
    }
    if (skeletalMusclePercent.present) {
      map['skeletal_muscle_percent'] = Variable<double>(
        skeletalMusclePercent.value,
      );
    }
    if (boneMassKg.present) {
      map['bone_mass_kg'] = Variable<double>(boneMassKg.value);
    }
    if (proteinKg.present) {
      map['protein_kg'] = Variable<double>(proteinKg.value);
    }
    if (visceralFat.present) {
      map['visceral_fat'] = Variable<int>(visceralFat.value);
    }
    if (totalBodyWaterKg.present) {
      map['total_body_water_kg'] = Variable<double>(totalBodyWaterKg.value);
    }
    if (totalBodyWaterPercent.present) {
      map['total_body_water_percent'] = Variable<double>(
        totalBodyWaterPercent.value,
      );
    }
    if (extracellularWaterKg.present) {
      map['extracellular_water_kg'] = Variable<double>(
        extracellularWaterKg.value,
      );
    }
    if (intracellularWaterKg.present) {
      map['intracellular_water_kg'] = Variable<double>(
        intracellularWaterKg.value,
      );
    }
    if (ecwOverTbwPercent.present) {
      map['ecw_over_tbw_percent'] = Variable<double>(ecwOverTbwPercent.value);
    }
    if (bmrKcal.present) {
      map['bmr_kcal'] = Variable<int>(bmrKcal.value);
    }
    if (bmrKj.present) {
      map['bmr_kj'] = Variable<int>(bmrKj.value);
    }
    if (metabolicAge.present) {
      map['metabolic_age'] = Variable<int>(metabolicAge.value);
    }
    if (sarcopenicIndex.present) {
      map['sarcopenic_index'] = Variable<double>(sarcopenicIndex.value);
    }
    if (phaseAngleDeg.present) {
      map['phase_angle_deg'] = Variable<double>(phaseAngleDeg.value);
    }
    if (impedanceOhm.present) {
      map['impedance_ohm'] = Variable<int>(impedanceOhm.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BodyMeasurementsCompanion(')
          ..write('day: $day, ')
          ..write('atMinutes: $atMinutes, ')
          ..write('weightKg: $weightKg, ')
          ..write('heightCm: $heightCm, ')
          ..write('bmi: $bmi, ')
          ..write('bodyFatPercent: $bodyFatPercent, ')
          ..write('fatMassKg: $fatMassKg, ')
          ..write('fatFreeMassKg: $fatFreeMassKg, ')
          ..write('muscleMassKg: $muscleMassKg, ')
          ..write('skeletalMuscleKg: $skeletalMuscleKg, ')
          ..write('skeletalMusclePercent: $skeletalMusclePercent, ')
          ..write('boneMassKg: $boneMassKg, ')
          ..write('proteinKg: $proteinKg, ')
          ..write('visceralFat: $visceralFat, ')
          ..write('totalBodyWaterKg: $totalBodyWaterKg, ')
          ..write('totalBodyWaterPercent: $totalBodyWaterPercent, ')
          ..write('extracellularWaterKg: $extracellularWaterKg, ')
          ..write('intracellularWaterKg: $intracellularWaterKg, ')
          ..write('ecwOverTbwPercent: $ecwOverTbwPercent, ')
          ..write('bmrKcal: $bmrKcal, ')
          ..write('bmrKj: $bmrKj, ')
          ..write('metabolicAge: $metabolicAge, ')
          ..write('sarcopenicIndex: $sarcopenicIndex, ')
          ..write('phaseAngleDeg: $phaseAngleDeg, ')
          ..write('impedanceOhm: $impedanceOhm, ')
          ..write('source: $source, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $BodySegmentsTable extends BodySegments
    with TableInfo<$BodySegmentsTable, BodySegmentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BodySegmentsTable(this.attachedDatabase, [this._alias]);
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
  late final GeneratedColumnWithTypeConverter<BodySegment, String> segment =
      GeneratedColumn<String>(
        'segment',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<BodySegment>($BodySegmentsTable.$convertersegment);
  static const VerificationMeta _fatPercentMeta = const VerificationMeta(
    'fatPercent',
  );
  @override
  late final GeneratedColumn<double> fatPercent = GeneratedColumn<double>(
    'fat_percent',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fatKgMeta = const VerificationMeta('fatKg');
  @override
  late final GeneratedColumn<double> fatKg = GeneratedColumn<double>(
    'fat_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _muscleKgMeta = const VerificationMeta(
    'muscleKg',
  );
  @override
  late final GeneratedColumn<double> muscleKg = GeneratedColumn<double>(
    'muscle_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fatFreeMassKgMeta = const VerificationMeta(
    'fatFreeMassKg',
  );
  @override
  late final GeneratedColumn<double> fatFreeMassKg = GeneratedColumn<double>(
    'fat_free_mass_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _otherMassKgMeta = const VerificationMeta(
    'otherMassKg',
  );
  @override
  late final GeneratedColumn<double> otherMassKg = GeneratedColumn<double>(
    'other_mass_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fatRatingMeta = const VerificationMeta(
    'fatRating',
  );
  @override
  late final GeneratedColumn<int> fatRating = GeneratedColumn<int>(
    'fat_rating',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _muscleRatingMeta = const VerificationMeta(
    'muscleRating',
  );
  @override
  late final GeneratedColumn<int> muscleRating = GeneratedColumn<int>(
    'muscle_rating',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    day,
    segment,
    fatPercent,
    fatKg,
    muscleKg,
    fatFreeMassKg,
    otherMassKg,
    fatRating,
    muscleRating,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'body_segments';
  @override
  VerificationContext validateIntegrity(
    Insertable<BodySegmentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('fat_percent')) {
      context.handle(
        _fatPercentMeta,
        fatPercent.isAcceptableOrUnknown(data['fat_percent']!, _fatPercentMeta),
      );
    }
    if (data.containsKey('fat_kg')) {
      context.handle(
        _fatKgMeta,
        fatKg.isAcceptableOrUnknown(data['fat_kg']!, _fatKgMeta),
      );
    }
    if (data.containsKey('muscle_kg')) {
      context.handle(
        _muscleKgMeta,
        muscleKg.isAcceptableOrUnknown(data['muscle_kg']!, _muscleKgMeta),
      );
    }
    if (data.containsKey('fat_free_mass_kg')) {
      context.handle(
        _fatFreeMassKgMeta,
        fatFreeMassKg.isAcceptableOrUnknown(
          data['fat_free_mass_kg']!,
          _fatFreeMassKgMeta,
        ),
      );
    }
    if (data.containsKey('other_mass_kg')) {
      context.handle(
        _otherMassKgMeta,
        otherMassKg.isAcceptableOrUnknown(
          data['other_mass_kg']!,
          _otherMassKgMeta,
        ),
      );
    }
    if (data.containsKey('fat_rating')) {
      context.handle(
        _fatRatingMeta,
        fatRating.isAcceptableOrUnknown(data['fat_rating']!, _fatRatingMeta),
      );
    }
    if (data.containsKey('muscle_rating')) {
      context.handle(
        _muscleRatingMeta,
        muscleRating.isAcceptableOrUnknown(
          data['muscle_rating']!,
          _muscleRatingMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {day, segment};
  @override
  BodySegmentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BodySegmentRow(
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day'],
      )!,
      segment: $BodySegmentsTable.$convertersegment.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}segment'],
        )!,
      ),
      fatPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_percent'],
      ),
      fatKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_kg'],
      ),
      muscleKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}muscle_kg'],
      ),
      fatFreeMassKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_free_mass_kg'],
      ),
      otherMassKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}other_mass_kg'],
      ),
      fatRating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fat_rating'],
      ),
      muscleRating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}muscle_rating'],
      ),
    );
  }

  @override
  $BodySegmentsTable createAlias(String alias) {
    return $BodySegmentsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<BodySegment, String, String> $convertersegment =
      const EnumNameConverter<BodySegment>(BodySegment.values);
}

class BodySegmentRow extends DataClass implements Insertable<BodySegmentRow> {
  final int day;

  /// trunk / rightArm / leftArm / rightLeg / leftLeg.
  final BodySegment segment;
  final double? fatPercent;
  final double? fatKg;
  final double? muscleKg;
  final double? fatFreeMassKg;
  final double? otherMassKg;

  /// Tanita's balance ratings, -4..+4, against its reference population.
  /// Stored as printed. What they MEAN is not the app's to say.
  final int? fatRating;
  final int? muscleRating;
  const BodySegmentRow({
    required this.day,
    required this.segment,
    this.fatPercent,
    this.fatKg,
    this.muscleKg,
    this.fatFreeMassKg,
    this.otherMassKg,
    this.fatRating,
    this.muscleRating,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['day'] = Variable<int>(day);
    {
      map['segment'] = Variable<String>(
        $BodySegmentsTable.$convertersegment.toSql(segment),
      );
    }
    if (!nullToAbsent || fatPercent != null) {
      map['fat_percent'] = Variable<double>(fatPercent);
    }
    if (!nullToAbsent || fatKg != null) {
      map['fat_kg'] = Variable<double>(fatKg);
    }
    if (!nullToAbsent || muscleKg != null) {
      map['muscle_kg'] = Variable<double>(muscleKg);
    }
    if (!nullToAbsent || fatFreeMassKg != null) {
      map['fat_free_mass_kg'] = Variable<double>(fatFreeMassKg);
    }
    if (!nullToAbsent || otherMassKg != null) {
      map['other_mass_kg'] = Variable<double>(otherMassKg);
    }
    if (!nullToAbsent || fatRating != null) {
      map['fat_rating'] = Variable<int>(fatRating);
    }
    if (!nullToAbsent || muscleRating != null) {
      map['muscle_rating'] = Variable<int>(muscleRating);
    }
    return map;
  }

  BodySegmentsCompanion toCompanion(bool nullToAbsent) {
    return BodySegmentsCompanion(
      day: Value(day),
      segment: Value(segment),
      fatPercent: fatPercent == null && nullToAbsent
          ? const Value.absent()
          : Value(fatPercent),
      fatKg: fatKg == null && nullToAbsent
          ? const Value.absent()
          : Value(fatKg),
      muscleKg: muscleKg == null && nullToAbsent
          ? const Value.absent()
          : Value(muscleKg),
      fatFreeMassKg: fatFreeMassKg == null && nullToAbsent
          ? const Value.absent()
          : Value(fatFreeMassKg),
      otherMassKg: otherMassKg == null && nullToAbsent
          ? const Value.absent()
          : Value(otherMassKg),
      fatRating: fatRating == null && nullToAbsent
          ? const Value.absent()
          : Value(fatRating),
      muscleRating: muscleRating == null && nullToAbsent
          ? const Value.absent()
          : Value(muscleRating),
    );
  }

  factory BodySegmentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BodySegmentRow(
      day: serializer.fromJson<int>(json['day']),
      segment: $BodySegmentsTable.$convertersegment.fromJson(
        serializer.fromJson<String>(json['segment']),
      ),
      fatPercent: serializer.fromJson<double?>(json['fatPercent']),
      fatKg: serializer.fromJson<double?>(json['fatKg']),
      muscleKg: serializer.fromJson<double?>(json['muscleKg']),
      fatFreeMassKg: serializer.fromJson<double?>(json['fatFreeMassKg']),
      otherMassKg: serializer.fromJson<double?>(json['otherMassKg']),
      fatRating: serializer.fromJson<int?>(json['fatRating']),
      muscleRating: serializer.fromJson<int?>(json['muscleRating']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'day': serializer.toJson<int>(day),
      'segment': serializer.toJson<String>(
        $BodySegmentsTable.$convertersegment.toJson(segment),
      ),
      'fatPercent': serializer.toJson<double?>(fatPercent),
      'fatKg': serializer.toJson<double?>(fatKg),
      'muscleKg': serializer.toJson<double?>(muscleKg),
      'fatFreeMassKg': serializer.toJson<double?>(fatFreeMassKg),
      'otherMassKg': serializer.toJson<double?>(otherMassKg),
      'fatRating': serializer.toJson<int?>(fatRating),
      'muscleRating': serializer.toJson<int?>(muscleRating),
    };
  }

  BodySegmentRow copyWith({
    int? day,
    BodySegment? segment,
    Value<double?> fatPercent = const Value.absent(),
    Value<double?> fatKg = const Value.absent(),
    Value<double?> muscleKg = const Value.absent(),
    Value<double?> fatFreeMassKg = const Value.absent(),
    Value<double?> otherMassKg = const Value.absent(),
    Value<int?> fatRating = const Value.absent(),
    Value<int?> muscleRating = const Value.absent(),
  }) => BodySegmentRow(
    day: day ?? this.day,
    segment: segment ?? this.segment,
    fatPercent: fatPercent.present ? fatPercent.value : this.fatPercent,
    fatKg: fatKg.present ? fatKg.value : this.fatKg,
    muscleKg: muscleKg.present ? muscleKg.value : this.muscleKg,
    fatFreeMassKg: fatFreeMassKg.present
        ? fatFreeMassKg.value
        : this.fatFreeMassKg,
    otherMassKg: otherMassKg.present ? otherMassKg.value : this.otherMassKg,
    fatRating: fatRating.present ? fatRating.value : this.fatRating,
    muscleRating: muscleRating.present ? muscleRating.value : this.muscleRating,
  );
  BodySegmentRow copyWithCompanion(BodySegmentsCompanion data) {
    return BodySegmentRow(
      day: data.day.present ? data.day.value : this.day,
      segment: data.segment.present ? data.segment.value : this.segment,
      fatPercent: data.fatPercent.present
          ? data.fatPercent.value
          : this.fatPercent,
      fatKg: data.fatKg.present ? data.fatKg.value : this.fatKg,
      muscleKg: data.muscleKg.present ? data.muscleKg.value : this.muscleKg,
      fatFreeMassKg: data.fatFreeMassKg.present
          ? data.fatFreeMassKg.value
          : this.fatFreeMassKg,
      otherMassKg: data.otherMassKg.present
          ? data.otherMassKg.value
          : this.otherMassKg,
      fatRating: data.fatRating.present ? data.fatRating.value : this.fatRating,
      muscleRating: data.muscleRating.present
          ? data.muscleRating.value
          : this.muscleRating,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BodySegmentRow(')
          ..write('day: $day, ')
          ..write('segment: $segment, ')
          ..write('fatPercent: $fatPercent, ')
          ..write('fatKg: $fatKg, ')
          ..write('muscleKg: $muscleKg, ')
          ..write('fatFreeMassKg: $fatFreeMassKg, ')
          ..write('otherMassKg: $otherMassKg, ')
          ..write('fatRating: $fatRating, ')
          ..write('muscleRating: $muscleRating')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    day,
    segment,
    fatPercent,
    fatKg,
    muscleKg,
    fatFreeMassKg,
    otherMassKg,
    fatRating,
    muscleRating,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BodySegmentRow &&
          other.day == this.day &&
          other.segment == this.segment &&
          other.fatPercent == this.fatPercent &&
          other.fatKg == this.fatKg &&
          other.muscleKg == this.muscleKg &&
          other.fatFreeMassKg == this.fatFreeMassKg &&
          other.otherMassKg == this.otherMassKg &&
          other.fatRating == this.fatRating &&
          other.muscleRating == this.muscleRating);
}

class BodySegmentsCompanion extends UpdateCompanion<BodySegmentRow> {
  final Value<int> day;
  final Value<BodySegment> segment;
  final Value<double?> fatPercent;
  final Value<double?> fatKg;
  final Value<double?> muscleKg;
  final Value<double?> fatFreeMassKg;
  final Value<double?> otherMassKg;
  final Value<int?> fatRating;
  final Value<int?> muscleRating;
  final Value<int> rowid;
  const BodySegmentsCompanion({
    this.day = const Value.absent(),
    this.segment = const Value.absent(),
    this.fatPercent = const Value.absent(),
    this.fatKg = const Value.absent(),
    this.muscleKg = const Value.absent(),
    this.fatFreeMassKg = const Value.absent(),
    this.otherMassKg = const Value.absent(),
    this.fatRating = const Value.absent(),
    this.muscleRating = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BodySegmentsCompanion.insert({
    required int day,
    required BodySegment segment,
    this.fatPercent = const Value.absent(),
    this.fatKg = const Value.absent(),
    this.muscleKg = const Value.absent(),
    this.fatFreeMassKg = const Value.absent(),
    this.otherMassKg = const Value.absent(),
    this.fatRating = const Value.absent(),
    this.muscleRating = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : day = Value(day),
       segment = Value(segment);
  static Insertable<BodySegmentRow> custom({
    Expression<int>? day,
    Expression<String>? segment,
    Expression<double>? fatPercent,
    Expression<double>? fatKg,
    Expression<double>? muscleKg,
    Expression<double>? fatFreeMassKg,
    Expression<double>? otherMassKg,
    Expression<int>? fatRating,
    Expression<int>? muscleRating,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (day != null) 'day': day,
      if (segment != null) 'segment': segment,
      if (fatPercent != null) 'fat_percent': fatPercent,
      if (fatKg != null) 'fat_kg': fatKg,
      if (muscleKg != null) 'muscle_kg': muscleKg,
      if (fatFreeMassKg != null) 'fat_free_mass_kg': fatFreeMassKg,
      if (otherMassKg != null) 'other_mass_kg': otherMassKg,
      if (fatRating != null) 'fat_rating': fatRating,
      if (muscleRating != null) 'muscle_rating': muscleRating,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BodySegmentsCompanion copyWith({
    Value<int>? day,
    Value<BodySegment>? segment,
    Value<double?>? fatPercent,
    Value<double?>? fatKg,
    Value<double?>? muscleKg,
    Value<double?>? fatFreeMassKg,
    Value<double?>? otherMassKg,
    Value<int?>? fatRating,
    Value<int?>? muscleRating,
    Value<int>? rowid,
  }) {
    return BodySegmentsCompanion(
      day: day ?? this.day,
      segment: segment ?? this.segment,
      fatPercent: fatPercent ?? this.fatPercent,
      fatKg: fatKg ?? this.fatKg,
      muscleKg: muscleKg ?? this.muscleKg,
      fatFreeMassKg: fatFreeMassKg ?? this.fatFreeMassKg,
      otherMassKg: otherMassKg ?? this.otherMassKg,
      fatRating: fatRating ?? this.fatRating,
      muscleRating: muscleRating ?? this.muscleRating,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (day.present) {
      map['day'] = Variable<int>(day.value);
    }
    if (segment.present) {
      map['segment'] = Variable<String>(
        $BodySegmentsTable.$convertersegment.toSql(segment.value),
      );
    }
    if (fatPercent.present) {
      map['fat_percent'] = Variable<double>(fatPercent.value);
    }
    if (fatKg.present) {
      map['fat_kg'] = Variable<double>(fatKg.value);
    }
    if (muscleKg.present) {
      map['muscle_kg'] = Variable<double>(muscleKg.value);
    }
    if (fatFreeMassKg.present) {
      map['fat_free_mass_kg'] = Variable<double>(fatFreeMassKg.value);
    }
    if (otherMassKg.present) {
      map['other_mass_kg'] = Variable<double>(otherMassKg.value);
    }
    if (fatRating.present) {
      map['fat_rating'] = Variable<int>(fatRating.value);
    }
    if (muscleRating.present) {
      map['muscle_rating'] = Variable<int>(muscleRating.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BodySegmentsCompanion(')
          ..write('day: $day, ')
          ..write('segment: $segment, ')
          ..write('fatPercent: $fatPercent, ')
          ..write('fatKg: $fatKg, ')
          ..write('muscleKg: $muscleKg, ')
          ..write('fatFreeMassKg: $fatFreeMassKg, ')
          ..write('otherMassKg: $otherMassKg, ')
          ..write('fatRating: $fatRating, ')
          ..write('muscleRating: $muscleRating, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LabResultsTable extends LabResults
    with TableInfo<$LabResultsTable, LabResultRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LabResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<int> day = GeneratedColumn<int>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _panelMeta = const VerificationMeta('panel');
  @override
  late final GeneratedColumn<String> panel = GeneratedColumn<String>(
    'panel',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _textValueMeta = const VerificationMeta(
    'textValue',
  );
  @override
  late final GeneratedColumn<String> textValue = GeneratedColumn<String>(
    'text_value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _refLowMeta = const VerificationMeta('refLow');
  @override
  late final GeneratedColumn<double> refLow = GeneratedColumn<double>(
    'ref_low',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _refHighMeta = const VerificationMeta(
    'refHigh',
  );
  @override
  late final GeneratedColumn<double> refHigh = GeneratedColumn<double>(
    'ref_high',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _refTextMeta = const VerificationMeta(
    'refText',
  );
  @override
  late final GeneratedColumn<String> refText = GeneratedColumn<String>(
    'ref_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _flagMeta = const VerificationMeta('flag');
  @override
  late final GeneratedColumn<String> flag = GeneratedColumn<String>(
    'flag',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    day,
    panel,
    name,
    value,
    textValue,
    unit,
    refLow,
    refHigh,
    refText,
    flag,
    source,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lab_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<LabResultRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('panel')) {
      context.handle(
        _panelMeta,
        panel.isAcceptableOrUnknown(data['panel']!, _panelMeta),
      );
    } else if (isInserting) {
      context.missing(_panelMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    if (data.containsKey('text_value')) {
      context.handle(
        _textValueMeta,
        textValue.isAcceptableOrUnknown(data['text_value']!, _textValueMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('ref_low')) {
      context.handle(
        _refLowMeta,
        refLow.isAcceptableOrUnknown(data['ref_low']!, _refLowMeta),
      );
    }
    if (data.containsKey('ref_high')) {
      context.handle(
        _refHighMeta,
        refHigh.isAcceptableOrUnknown(data['ref_high']!, _refHighMeta),
      );
    }
    if (data.containsKey('ref_text')) {
      context.handle(
        _refTextMeta,
        refText.isAcceptableOrUnknown(data['ref_text']!, _refTextMeta),
      );
    }
    if (data.containsKey('flag')) {
      context.handle(
        _flagMeta,
        flag.isAcceptableOrUnknown(data['flag']!, _flagMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {day, panel, name};
  @override
  LabResultRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LabResultRow(
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day'],
      )!,
      panel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}panel'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      ),
      textValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_value'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      refLow: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ref_low'],
      ),
      refHigh: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ref_high'],
      ),
      refText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ref_text'],
      )!,
      flag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}flag'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
    );
  }

  @override
  $LabResultsTable createAlias(String alias) {
    return $LabResultsTable(attachedDatabase, alias);
  }
}

class LabResultRow extends DataClass implements Insertable<LabResultRow> {
  final int day;

  /// Which group it was printed under: LIPID, LIVER, HEMOGRAM, VITALS.
  final String panel;
  final String name;

  /// Null for a text result like ABSENT, which lives in [textValue].
  final double? value;
  final String? textValue;
  final String unit;
  final double? refLow;
  final double? refHigh;

  /// The range exactly as printed, for anything the two numbers cannot carry
  /// ("< 45", "9:1-23:1", "Adult : 17-43").
  final String refText;

  /// As flagged on the report: '', 'high', 'low'. Copied, not decided.
  final String flag;
  final String source;
  const LabResultRow({
    required this.day,
    required this.panel,
    required this.name,
    this.value,
    this.textValue,
    required this.unit,
    this.refLow,
    this.refHigh,
    required this.refText,
    required this.flag,
    required this.source,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['day'] = Variable<int>(day);
    map['panel'] = Variable<String>(panel);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<double>(value);
    }
    if (!nullToAbsent || textValue != null) {
      map['text_value'] = Variable<String>(textValue);
    }
    map['unit'] = Variable<String>(unit);
    if (!nullToAbsent || refLow != null) {
      map['ref_low'] = Variable<double>(refLow);
    }
    if (!nullToAbsent || refHigh != null) {
      map['ref_high'] = Variable<double>(refHigh);
    }
    map['ref_text'] = Variable<String>(refText);
    map['flag'] = Variable<String>(flag);
    map['source'] = Variable<String>(source);
    return map;
  }

  LabResultsCompanion toCompanion(bool nullToAbsent) {
    return LabResultsCompanion(
      day: Value(day),
      panel: Value(panel),
      name: Value(name),
      value: value == null && nullToAbsent
          ? const Value.absent()
          : Value(value),
      textValue: textValue == null && nullToAbsent
          ? const Value.absent()
          : Value(textValue),
      unit: Value(unit),
      refLow: refLow == null && nullToAbsent
          ? const Value.absent()
          : Value(refLow),
      refHigh: refHigh == null && nullToAbsent
          ? const Value.absent()
          : Value(refHigh),
      refText: Value(refText),
      flag: Value(flag),
      source: Value(source),
    );
  }

  factory LabResultRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LabResultRow(
      day: serializer.fromJson<int>(json['day']),
      panel: serializer.fromJson<String>(json['panel']),
      name: serializer.fromJson<String>(json['name']),
      value: serializer.fromJson<double?>(json['value']),
      textValue: serializer.fromJson<String?>(json['textValue']),
      unit: serializer.fromJson<String>(json['unit']),
      refLow: serializer.fromJson<double?>(json['refLow']),
      refHigh: serializer.fromJson<double?>(json['refHigh']),
      refText: serializer.fromJson<String>(json['refText']),
      flag: serializer.fromJson<String>(json['flag']),
      source: serializer.fromJson<String>(json['source']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'day': serializer.toJson<int>(day),
      'panel': serializer.toJson<String>(panel),
      'name': serializer.toJson<String>(name),
      'value': serializer.toJson<double?>(value),
      'textValue': serializer.toJson<String?>(textValue),
      'unit': serializer.toJson<String>(unit),
      'refLow': serializer.toJson<double?>(refLow),
      'refHigh': serializer.toJson<double?>(refHigh),
      'refText': serializer.toJson<String>(refText),
      'flag': serializer.toJson<String>(flag),
      'source': serializer.toJson<String>(source),
    };
  }

  LabResultRow copyWith({
    int? day,
    String? panel,
    String? name,
    Value<double?> value = const Value.absent(),
    Value<String?> textValue = const Value.absent(),
    String? unit,
    Value<double?> refLow = const Value.absent(),
    Value<double?> refHigh = const Value.absent(),
    String? refText,
    String? flag,
    String? source,
  }) => LabResultRow(
    day: day ?? this.day,
    panel: panel ?? this.panel,
    name: name ?? this.name,
    value: value.present ? value.value : this.value,
    textValue: textValue.present ? textValue.value : this.textValue,
    unit: unit ?? this.unit,
    refLow: refLow.present ? refLow.value : this.refLow,
    refHigh: refHigh.present ? refHigh.value : this.refHigh,
    refText: refText ?? this.refText,
    flag: flag ?? this.flag,
    source: source ?? this.source,
  );
  LabResultRow copyWithCompanion(LabResultsCompanion data) {
    return LabResultRow(
      day: data.day.present ? data.day.value : this.day,
      panel: data.panel.present ? data.panel.value : this.panel,
      name: data.name.present ? data.name.value : this.name,
      value: data.value.present ? data.value.value : this.value,
      textValue: data.textValue.present ? data.textValue.value : this.textValue,
      unit: data.unit.present ? data.unit.value : this.unit,
      refLow: data.refLow.present ? data.refLow.value : this.refLow,
      refHigh: data.refHigh.present ? data.refHigh.value : this.refHigh,
      refText: data.refText.present ? data.refText.value : this.refText,
      flag: data.flag.present ? data.flag.value : this.flag,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LabResultRow(')
          ..write('day: $day, ')
          ..write('panel: $panel, ')
          ..write('name: $name, ')
          ..write('value: $value, ')
          ..write('textValue: $textValue, ')
          ..write('unit: $unit, ')
          ..write('refLow: $refLow, ')
          ..write('refHigh: $refHigh, ')
          ..write('refText: $refText, ')
          ..write('flag: $flag, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    day,
    panel,
    name,
    value,
    textValue,
    unit,
    refLow,
    refHigh,
    refText,
    flag,
    source,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LabResultRow &&
          other.day == this.day &&
          other.panel == this.panel &&
          other.name == this.name &&
          other.value == this.value &&
          other.textValue == this.textValue &&
          other.unit == this.unit &&
          other.refLow == this.refLow &&
          other.refHigh == this.refHigh &&
          other.refText == this.refText &&
          other.flag == this.flag &&
          other.source == this.source);
}

class LabResultsCompanion extends UpdateCompanion<LabResultRow> {
  final Value<int> day;
  final Value<String> panel;
  final Value<String> name;
  final Value<double?> value;
  final Value<String?> textValue;
  final Value<String> unit;
  final Value<double?> refLow;
  final Value<double?> refHigh;
  final Value<String> refText;
  final Value<String> flag;
  final Value<String> source;
  final Value<int> rowid;
  const LabResultsCompanion({
    this.day = const Value.absent(),
    this.panel = const Value.absent(),
    this.name = const Value.absent(),
    this.value = const Value.absent(),
    this.textValue = const Value.absent(),
    this.unit = const Value.absent(),
    this.refLow = const Value.absent(),
    this.refHigh = const Value.absent(),
    this.refText = const Value.absent(),
    this.flag = const Value.absent(),
    this.source = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LabResultsCompanion.insert({
    required int day,
    required String panel,
    required String name,
    this.value = const Value.absent(),
    this.textValue = const Value.absent(),
    this.unit = const Value.absent(),
    this.refLow = const Value.absent(),
    this.refHigh = const Value.absent(),
    this.refText = const Value.absent(),
    this.flag = const Value.absent(),
    this.source = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : day = Value(day),
       panel = Value(panel),
       name = Value(name);
  static Insertable<LabResultRow> custom({
    Expression<int>? day,
    Expression<String>? panel,
    Expression<String>? name,
    Expression<double>? value,
    Expression<String>? textValue,
    Expression<String>? unit,
    Expression<double>? refLow,
    Expression<double>? refHigh,
    Expression<String>? refText,
    Expression<String>? flag,
    Expression<String>? source,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (day != null) 'day': day,
      if (panel != null) 'panel': panel,
      if (name != null) 'name': name,
      if (value != null) 'value': value,
      if (textValue != null) 'text_value': textValue,
      if (unit != null) 'unit': unit,
      if (refLow != null) 'ref_low': refLow,
      if (refHigh != null) 'ref_high': refHigh,
      if (refText != null) 'ref_text': refText,
      if (flag != null) 'flag': flag,
      if (source != null) 'source': source,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LabResultsCompanion copyWith({
    Value<int>? day,
    Value<String>? panel,
    Value<String>? name,
    Value<double?>? value,
    Value<String?>? textValue,
    Value<String>? unit,
    Value<double?>? refLow,
    Value<double?>? refHigh,
    Value<String>? refText,
    Value<String>? flag,
    Value<String>? source,
    Value<int>? rowid,
  }) {
    return LabResultsCompanion(
      day: day ?? this.day,
      panel: panel ?? this.panel,
      name: name ?? this.name,
      value: value ?? this.value,
      textValue: textValue ?? this.textValue,
      unit: unit ?? this.unit,
      refLow: refLow ?? this.refLow,
      refHigh: refHigh ?? this.refHigh,
      refText: refText ?? this.refText,
      flag: flag ?? this.flag,
      source: source ?? this.source,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (day.present) {
      map['day'] = Variable<int>(day.value);
    }
    if (panel.present) {
      map['panel'] = Variable<String>(panel.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (textValue.present) {
      map['text_value'] = Variable<String>(textValue.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (refLow.present) {
      map['ref_low'] = Variable<double>(refLow.value);
    }
    if (refHigh.present) {
      map['ref_high'] = Variable<double>(refHigh.value);
    }
    if (refText.present) {
      map['ref_text'] = Variable<String>(refText.value);
    }
    if (flag.present) {
      map['flag'] = Variable<String>(flag.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LabResultsCompanion(')
          ..write('day: $day, ')
          ..write('panel: $panel, ')
          ..write('name: $name, ')
          ..write('value: $value, ')
          ..write('textValue: $textValue, ')
          ..write('unit: $unit, ')
          ..write('refLow: $refLow, ')
          ..write('refHigh: $refHigh, ')
          ..write('refText: $refText, ')
          ..write('flag: $flag, ')
          ..write('source: $source, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HealthDaysTable extends HealthDays
    with TableInfo<$HealthDaysTable, HealthDayRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HealthDaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<int> day = GeneratedColumn<int>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stepsMeta = const VerificationMeta('steps');
  @override
  late final GeneratedColumn<int> steps = GeneratedColumn<int>(
    'steps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sleepMinutesMeta = const VerificationMeta(
    'sleepMinutes',
  );
  @override
  late final GeneratedColumn<int> sleepMinutes = GeneratedColumn<int>(
    'sleep_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _restingHeartRateMeta = const VerificationMeta(
    'restingHeartRate',
  );
  @override
  late final GeneratedColumn<int> restingHeartRate = GeneratedColumn<int>(
    'resting_heart_rate',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeKcalMeta = const VerificationMeta(
    'activeKcal',
  );
  @override
  late final GeneratedColumn<int> activeKcal = GeneratedColumn<int>(
    'active_kcal',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _distanceMMeta = const VerificationMeta(
    'distanceM',
  );
  @override
  late final GeneratedColumn<int> distanceM = GeneratedColumn<int>(
    'distance_m',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _workoutMinutesMeta = const VerificationMeta(
    'workoutMinutes',
  );
  @override
  late final GeneratedColumn<int> workoutMinutes = GeneratedColumn<int>(
    'workout_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    day,
    steps,
    sleepMinutes,
    restingHeartRate,
    activeKcal,
    distanceM,
    workoutMinutes,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'health_days';
  @override
  VerificationContext validateIntegrity(
    Insertable<HealthDayRow> instance, {
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
    if (data.containsKey('steps')) {
      context.handle(
        _stepsMeta,
        steps.isAcceptableOrUnknown(data['steps']!, _stepsMeta),
      );
    }
    if (data.containsKey('sleep_minutes')) {
      context.handle(
        _sleepMinutesMeta,
        sleepMinutes.isAcceptableOrUnknown(
          data['sleep_minutes']!,
          _sleepMinutesMeta,
        ),
      );
    }
    if (data.containsKey('resting_heart_rate')) {
      context.handle(
        _restingHeartRateMeta,
        restingHeartRate.isAcceptableOrUnknown(
          data['resting_heart_rate']!,
          _restingHeartRateMeta,
        ),
      );
    }
    if (data.containsKey('active_kcal')) {
      context.handle(
        _activeKcalMeta,
        activeKcal.isAcceptableOrUnknown(data['active_kcal']!, _activeKcalMeta),
      );
    }
    if (data.containsKey('distance_m')) {
      context.handle(
        _distanceMMeta,
        distanceM.isAcceptableOrUnknown(data['distance_m']!, _distanceMMeta),
      );
    }
    if (data.containsKey('workout_minutes')) {
      context.handle(
        _workoutMinutesMeta,
        workoutMinutes.isAcceptableOrUnknown(
          data['workout_minutes']!,
          _workoutMinutesMeta,
        ),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_syncedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {day};
  @override
  HealthDayRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HealthDayRow(
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day'],
      )!,
      steps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}steps'],
      ),
      sleepMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sleep_minutes'],
      ),
      restingHeartRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}resting_heart_rate'],
      ),
      activeKcal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}active_kcal'],
      ),
      distanceM: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}distance_m'],
      ),
      workoutMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}workout_minutes'],
      ),
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      )!,
    );
  }

  @override
  $HealthDaysTable createAlias(String alias) {
    return $HealthDaysTable(attachedDatabase, alias);
  }
}

class HealthDayRow extends DataClass implements Insertable<HealthDayRow> {
  final int day;
  final int? steps;

  /// Total asleep time in minutes — not time in bed.
  final int? sleepMinutes;

  /// Beats per minute. Resting is the one worth trending; a workout average
  /// says more about the workout than about the body.
  final int? restingHeartRate;
  final int? activeKcal;

  /// Metres, the unit Health Connect reports in. Converted for display only.
  final int? distanceM;

  /// Minutes of recorded exercise. What auto-verifies the running quest.
  final int? workoutMinutes;

  /// When this row was last refreshed, so a stale day can be re-synced.
  final DateTime syncedAt;
  const HealthDayRow({
    required this.day,
    this.steps,
    this.sleepMinutes,
    this.restingHeartRate,
    this.activeKcal,
    this.distanceM,
    this.workoutMinutes,
    required this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['day'] = Variable<int>(day);
    if (!nullToAbsent || steps != null) {
      map['steps'] = Variable<int>(steps);
    }
    if (!nullToAbsent || sleepMinutes != null) {
      map['sleep_minutes'] = Variable<int>(sleepMinutes);
    }
    if (!nullToAbsent || restingHeartRate != null) {
      map['resting_heart_rate'] = Variable<int>(restingHeartRate);
    }
    if (!nullToAbsent || activeKcal != null) {
      map['active_kcal'] = Variable<int>(activeKcal);
    }
    if (!nullToAbsent || distanceM != null) {
      map['distance_m'] = Variable<int>(distanceM);
    }
    if (!nullToAbsent || workoutMinutes != null) {
      map['workout_minutes'] = Variable<int>(workoutMinutes);
    }
    map['synced_at'] = Variable<DateTime>(syncedAt);
    return map;
  }

  HealthDaysCompanion toCompanion(bool nullToAbsent) {
    return HealthDaysCompanion(
      day: Value(day),
      steps: steps == null && nullToAbsent
          ? const Value.absent()
          : Value(steps),
      sleepMinutes: sleepMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(sleepMinutes),
      restingHeartRate: restingHeartRate == null && nullToAbsent
          ? const Value.absent()
          : Value(restingHeartRate),
      activeKcal: activeKcal == null && nullToAbsent
          ? const Value.absent()
          : Value(activeKcal),
      distanceM: distanceM == null && nullToAbsent
          ? const Value.absent()
          : Value(distanceM),
      workoutMinutes: workoutMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(workoutMinutes),
      syncedAt: Value(syncedAt),
    );
  }

  factory HealthDayRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HealthDayRow(
      day: serializer.fromJson<int>(json['day']),
      steps: serializer.fromJson<int?>(json['steps']),
      sleepMinutes: serializer.fromJson<int?>(json['sleepMinutes']),
      restingHeartRate: serializer.fromJson<int?>(json['restingHeartRate']),
      activeKcal: serializer.fromJson<int?>(json['activeKcal']),
      distanceM: serializer.fromJson<int?>(json['distanceM']),
      workoutMinutes: serializer.fromJson<int?>(json['workoutMinutes']),
      syncedAt: serializer.fromJson<DateTime>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'day': serializer.toJson<int>(day),
      'steps': serializer.toJson<int?>(steps),
      'sleepMinutes': serializer.toJson<int?>(sleepMinutes),
      'restingHeartRate': serializer.toJson<int?>(restingHeartRate),
      'activeKcal': serializer.toJson<int?>(activeKcal),
      'distanceM': serializer.toJson<int?>(distanceM),
      'workoutMinutes': serializer.toJson<int?>(workoutMinutes),
      'syncedAt': serializer.toJson<DateTime>(syncedAt),
    };
  }

  HealthDayRow copyWith({
    int? day,
    Value<int?> steps = const Value.absent(),
    Value<int?> sleepMinutes = const Value.absent(),
    Value<int?> restingHeartRate = const Value.absent(),
    Value<int?> activeKcal = const Value.absent(),
    Value<int?> distanceM = const Value.absent(),
    Value<int?> workoutMinutes = const Value.absent(),
    DateTime? syncedAt,
  }) => HealthDayRow(
    day: day ?? this.day,
    steps: steps.present ? steps.value : this.steps,
    sleepMinutes: sleepMinutes.present ? sleepMinutes.value : this.sleepMinutes,
    restingHeartRate: restingHeartRate.present
        ? restingHeartRate.value
        : this.restingHeartRate,
    activeKcal: activeKcal.present ? activeKcal.value : this.activeKcal,
    distanceM: distanceM.present ? distanceM.value : this.distanceM,
    workoutMinutes: workoutMinutes.present
        ? workoutMinutes.value
        : this.workoutMinutes,
    syncedAt: syncedAt ?? this.syncedAt,
  );
  HealthDayRow copyWithCompanion(HealthDaysCompanion data) {
    return HealthDayRow(
      day: data.day.present ? data.day.value : this.day,
      steps: data.steps.present ? data.steps.value : this.steps,
      sleepMinutes: data.sleepMinutes.present
          ? data.sleepMinutes.value
          : this.sleepMinutes,
      restingHeartRate: data.restingHeartRate.present
          ? data.restingHeartRate.value
          : this.restingHeartRate,
      activeKcal: data.activeKcal.present
          ? data.activeKcal.value
          : this.activeKcal,
      distanceM: data.distanceM.present ? data.distanceM.value : this.distanceM,
      workoutMinutes: data.workoutMinutes.present
          ? data.workoutMinutes.value
          : this.workoutMinutes,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HealthDayRow(')
          ..write('day: $day, ')
          ..write('steps: $steps, ')
          ..write('sleepMinutes: $sleepMinutes, ')
          ..write('restingHeartRate: $restingHeartRate, ')
          ..write('activeKcal: $activeKcal, ')
          ..write('distanceM: $distanceM, ')
          ..write('workoutMinutes: $workoutMinutes, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    day,
    steps,
    sleepMinutes,
    restingHeartRate,
    activeKcal,
    distanceM,
    workoutMinutes,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HealthDayRow &&
          other.day == this.day &&
          other.steps == this.steps &&
          other.sleepMinutes == this.sleepMinutes &&
          other.restingHeartRate == this.restingHeartRate &&
          other.activeKcal == this.activeKcal &&
          other.distanceM == this.distanceM &&
          other.workoutMinutes == this.workoutMinutes &&
          other.syncedAt == this.syncedAt);
}

class HealthDaysCompanion extends UpdateCompanion<HealthDayRow> {
  final Value<int> day;
  final Value<int?> steps;
  final Value<int?> sleepMinutes;
  final Value<int?> restingHeartRate;
  final Value<int?> activeKcal;
  final Value<int?> distanceM;
  final Value<int?> workoutMinutes;
  final Value<DateTime> syncedAt;
  const HealthDaysCompanion({
    this.day = const Value.absent(),
    this.steps = const Value.absent(),
    this.sleepMinutes = const Value.absent(),
    this.restingHeartRate = const Value.absent(),
    this.activeKcal = const Value.absent(),
    this.distanceM = const Value.absent(),
    this.workoutMinutes = const Value.absent(),
    this.syncedAt = const Value.absent(),
  });
  HealthDaysCompanion.insert({
    this.day = const Value.absent(),
    this.steps = const Value.absent(),
    this.sleepMinutes = const Value.absent(),
    this.restingHeartRate = const Value.absent(),
    this.activeKcal = const Value.absent(),
    this.distanceM = const Value.absent(),
    this.workoutMinutes = const Value.absent(),
    required DateTime syncedAt,
  }) : syncedAt = Value(syncedAt);
  static Insertable<HealthDayRow> custom({
    Expression<int>? day,
    Expression<int>? steps,
    Expression<int>? sleepMinutes,
    Expression<int>? restingHeartRate,
    Expression<int>? activeKcal,
    Expression<int>? distanceM,
    Expression<int>? workoutMinutes,
    Expression<DateTime>? syncedAt,
  }) {
    return RawValuesInsertable({
      if (day != null) 'day': day,
      if (steps != null) 'steps': steps,
      if (sleepMinutes != null) 'sleep_minutes': sleepMinutes,
      if (restingHeartRate != null) 'resting_heart_rate': restingHeartRate,
      if (activeKcal != null) 'active_kcal': activeKcal,
      if (distanceM != null) 'distance_m': distanceM,
      if (workoutMinutes != null) 'workout_minutes': workoutMinutes,
      if (syncedAt != null) 'synced_at': syncedAt,
    });
  }

  HealthDaysCompanion copyWith({
    Value<int>? day,
    Value<int?>? steps,
    Value<int?>? sleepMinutes,
    Value<int?>? restingHeartRate,
    Value<int?>? activeKcal,
    Value<int?>? distanceM,
    Value<int?>? workoutMinutes,
    Value<DateTime>? syncedAt,
  }) {
    return HealthDaysCompanion(
      day: day ?? this.day,
      steps: steps ?? this.steps,
      sleepMinutes: sleepMinutes ?? this.sleepMinutes,
      restingHeartRate: restingHeartRate ?? this.restingHeartRate,
      activeKcal: activeKcal ?? this.activeKcal,
      distanceM: distanceM ?? this.distanceM,
      workoutMinutes: workoutMinutes ?? this.workoutMinutes,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (day.present) {
      map['day'] = Variable<int>(day.value);
    }
    if (steps.present) {
      map['steps'] = Variable<int>(steps.value);
    }
    if (sleepMinutes.present) {
      map['sleep_minutes'] = Variable<int>(sleepMinutes.value);
    }
    if (restingHeartRate.present) {
      map['resting_heart_rate'] = Variable<int>(restingHeartRate.value);
    }
    if (activeKcal.present) {
      map['active_kcal'] = Variable<int>(activeKcal.value);
    }
    if (distanceM.present) {
      map['distance_m'] = Variable<int>(distanceM.value);
    }
    if (workoutMinutes.present) {
      map['workout_minutes'] = Variable<int>(workoutMinutes.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HealthDaysCompanion(')
          ..write('day: $day, ')
          ..write('steps: $steps, ')
          ..write('sleepMinutes: $sleepMinutes, ')
          ..write('restingHeartRate: $restingHeartRate, ')
          ..write('activeKcal: $activeKcal, ')
          ..write('distanceM: $distanceM, ')
          ..write('workoutMinutes: $workoutMinutes, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }
}

class $WeeklyReviewsTable extends WeeklyReviews
    with TableInfo<$WeeklyReviewsTable, WeeklyReviewRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeeklyReviewsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _weekEndDayMeta = const VerificationMeta(
    'weekEndDay',
  );
  @override
  late final GeneratedColumn<int> weekEndDay = GeneratedColumn<int>(
    'week_end_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _keptMeta = const VerificationMeta('kept');
  @override
  late final GeneratedColumn<String> kept = GeneratedColumn<String>(
    'kept',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _changeMeta = const VerificationMeta('change');
  @override
  late final GeneratedColumn<String> change = GeneratedColumn<String>(
    'change',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('figures'),
  );
  static const VerificationMeta _generatedAtMeta = const VerificationMeta(
    'generatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> generatedAt = GeneratedColumn<DateTime>(
    'generated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    weekEndDay,
    summary,
    kept,
    change,
    source,
    generatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weekly_reviews';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeeklyReviewRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('week_end_day')) {
      context.handle(
        _weekEndDayMeta,
        weekEndDay.isAcceptableOrUnknown(
          data['week_end_day']!,
          _weekEndDayMeta,
        ),
      );
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    } else if (isInserting) {
      context.missing(_summaryMeta);
    }
    if (data.containsKey('kept')) {
      context.handle(
        _keptMeta,
        kept.isAcceptableOrUnknown(data['kept']!, _keptMeta),
      );
    } else if (isInserting) {
      context.missing(_keptMeta);
    }
    if (data.containsKey('change')) {
      context.handle(
        _changeMeta,
        change.isAcceptableOrUnknown(data['change']!, _changeMeta),
      );
    } else if (isInserting) {
      context.missing(_changeMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('generated_at')) {
      context.handle(
        _generatedAtMeta,
        generatedAt.isAcceptableOrUnknown(
          data['generated_at']!,
          _generatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_generatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {weekEndDay};
  @override
  WeeklyReviewRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeeklyReviewRow(
      weekEndDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}week_end_day'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      )!,
      kept: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kept'],
      )!,
      change: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}change'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      generatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}generated_at'],
      )!,
    );
  }

  @override
  $WeeklyReviewsTable createAlias(String alias) {
    return $WeeklyReviewsTable(attachedDatabase, alias);
  }
}

class WeeklyReviewRow extends DataClass implements Insertable<WeeklyReviewRow> {
  /// Day number of the Sunday this review covers.
  final int weekEndDay;
  final String summary;
  final String kept;
  final String change;

  /// 'model' when a provider wrote it, 'figures' when it was assembled from
  /// the numbers alone. Shown, because they deserve different trust — the same
  /// rule the trainer note follows.
  final String source;
  final DateTime generatedAt;
  const WeeklyReviewRow({
    required this.weekEndDay,
    required this.summary,
    required this.kept,
    required this.change,
    required this.source,
    required this.generatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['week_end_day'] = Variable<int>(weekEndDay);
    map['summary'] = Variable<String>(summary);
    map['kept'] = Variable<String>(kept);
    map['change'] = Variable<String>(change);
    map['source'] = Variable<String>(source);
    map['generated_at'] = Variable<DateTime>(generatedAt);
    return map;
  }

  WeeklyReviewsCompanion toCompanion(bool nullToAbsent) {
    return WeeklyReviewsCompanion(
      weekEndDay: Value(weekEndDay),
      summary: Value(summary),
      kept: Value(kept),
      change: Value(change),
      source: Value(source),
      generatedAt: Value(generatedAt),
    );
  }

  factory WeeklyReviewRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeeklyReviewRow(
      weekEndDay: serializer.fromJson<int>(json['weekEndDay']),
      summary: serializer.fromJson<String>(json['summary']),
      kept: serializer.fromJson<String>(json['kept']),
      change: serializer.fromJson<String>(json['change']),
      source: serializer.fromJson<String>(json['source']),
      generatedAt: serializer.fromJson<DateTime>(json['generatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'weekEndDay': serializer.toJson<int>(weekEndDay),
      'summary': serializer.toJson<String>(summary),
      'kept': serializer.toJson<String>(kept),
      'change': serializer.toJson<String>(change),
      'source': serializer.toJson<String>(source),
      'generatedAt': serializer.toJson<DateTime>(generatedAt),
    };
  }

  WeeklyReviewRow copyWith({
    int? weekEndDay,
    String? summary,
    String? kept,
    String? change,
    String? source,
    DateTime? generatedAt,
  }) => WeeklyReviewRow(
    weekEndDay: weekEndDay ?? this.weekEndDay,
    summary: summary ?? this.summary,
    kept: kept ?? this.kept,
    change: change ?? this.change,
    source: source ?? this.source,
    generatedAt: generatedAt ?? this.generatedAt,
  );
  WeeklyReviewRow copyWithCompanion(WeeklyReviewsCompanion data) {
    return WeeklyReviewRow(
      weekEndDay: data.weekEndDay.present
          ? data.weekEndDay.value
          : this.weekEndDay,
      summary: data.summary.present ? data.summary.value : this.summary,
      kept: data.kept.present ? data.kept.value : this.kept,
      change: data.change.present ? data.change.value : this.change,
      source: data.source.present ? data.source.value : this.source,
      generatedAt: data.generatedAt.present
          ? data.generatedAt.value
          : this.generatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyReviewRow(')
          ..write('weekEndDay: $weekEndDay, ')
          ..write('summary: $summary, ')
          ..write('kept: $kept, ')
          ..write('change: $change, ')
          ..write('source: $source, ')
          ..write('generatedAt: $generatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(weekEndDay, summary, kept, change, source, generatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeeklyReviewRow &&
          other.weekEndDay == this.weekEndDay &&
          other.summary == this.summary &&
          other.kept == this.kept &&
          other.change == this.change &&
          other.source == this.source &&
          other.generatedAt == this.generatedAt);
}

class WeeklyReviewsCompanion extends UpdateCompanion<WeeklyReviewRow> {
  final Value<int> weekEndDay;
  final Value<String> summary;
  final Value<String> kept;
  final Value<String> change;
  final Value<String> source;
  final Value<DateTime> generatedAt;
  const WeeklyReviewsCompanion({
    this.weekEndDay = const Value.absent(),
    this.summary = const Value.absent(),
    this.kept = const Value.absent(),
    this.change = const Value.absent(),
    this.source = const Value.absent(),
    this.generatedAt = const Value.absent(),
  });
  WeeklyReviewsCompanion.insert({
    this.weekEndDay = const Value.absent(),
    required String summary,
    required String kept,
    required String change,
    this.source = const Value.absent(),
    required DateTime generatedAt,
  }) : summary = Value(summary),
       kept = Value(kept),
       change = Value(change),
       generatedAt = Value(generatedAt);
  static Insertable<WeeklyReviewRow> custom({
    Expression<int>? weekEndDay,
    Expression<String>? summary,
    Expression<String>? kept,
    Expression<String>? change,
    Expression<String>? source,
    Expression<DateTime>? generatedAt,
  }) {
    return RawValuesInsertable({
      if (weekEndDay != null) 'week_end_day': weekEndDay,
      if (summary != null) 'summary': summary,
      if (kept != null) 'kept': kept,
      if (change != null) 'change': change,
      if (source != null) 'source': source,
      if (generatedAt != null) 'generated_at': generatedAt,
    });
  }

  WeeklyReviewsCompanion copyWith({
    Value<int>? weekEndDay,
    Value<String>? summary,
    Value<String>? kept,
    Value<String>? change,
    Value<String>? source,
    Value<DateTime>? generatedAt,
  }) {
    return WeeklyReviewsCompanion(
      weekEndDay: weekEndDay ?? this.weekEndDay,
      summary: summary ?? this.summary,
      kept: kept ?? this.kept,
      change: change ?? this.change,
      source: source ?? this.source,
      generatedAt: generatedAt ?? this.generatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (weekEndDay.present) {
      map['week_end_day'] = Variable<int>(weekEndDay.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (kept.present) {
      map['kept'] = Variable<String>(kept.value);
    }
    if (change.present) {
      map['change'] = Variable<String>(change.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (generatedAt.present) {
      map['generated_at'] = Variable<DateTime>(generatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyReviewsCompanion(')
          ..write('weekEndDay: $weekEndDay, ')
          ..write('summary: $summary, ')
          ..write('kept: $kept, ')
          ..write('change: $change, ')
          ..write('source: $source, ')
          ..write('generatedAt: $generatedAt')
          ..write(')'))
        .toString();
  }
}

class $DeloadsTable extends Deloads with TableInfo<$DeloadsTable, DeloadRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeloadsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _startDayMeta = const VerificationMeta(
    'startDay',
  );
  @override
  late final GeneratedColumn<int> startDay = GeneratedColumn<int>(
    'start_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _decidedAtMeta = const VerificationMeta(
    'decidedAt',
  );
  @override
  late final GeneratedColumn<DateTime> decidedAt = GeneratedColumn<DateTime>(
    'decided_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [startDay, reason, decidedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deloads';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeloadRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('start_day')) {
      context.handle(
        _startDayMeta,
        startDay.isAcceptableOrUnknown(data['start_day']!, _startDayMeta),
      );
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('decided_at')) {
      context.handle(
        _decidedAtMeta,
        decidedAt.isAcceptableOrUnknown(data['decided_at']!, _decidedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_decidedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {startDay};
  @override
  DeloadRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeloadRow(
      startDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_day'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      decidedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}decided_at'],
      )!,
    );
  }

  @override
  $DeloadsTable createAlias(String alias) {
    return $DeloadsTable(attachedDatabase, alias);
  }
}

class DeloadRow extends DataClass implements Insertable<DeloadRow> {
  /// Day number of the Monday the deload week began.
  final int startDay;

  /// 'planned' or 'stalled'.
  final String reason;
  final DateTime decidedAt;
  const DeloadRow({
    required this.startDay,
    required this.reason,
    required this.decidedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['start_day'] = Variable<int>(startDay);
    map['reason'] = Variable<String>(reason);
    map['decided_at'] = Variable<DateTime>(decidedAt);
    return map;
  }

  DeloadsCompanion toCompanion(bool nullToAbsent) {
    return DeloadsCompanion(
      startDay: Value(startDay),
      reason: Value(reason),
      decidedAt: Value(decidedAt),
    );
  }

  factory DeloadRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeloadRow(
      startDay: serializer.fromJson<int>(json['startDay']),
      reason: serializer.fromJson<String>(json['reason']),
      decidedAt: serializer.fromJson<DateTime>(json['decidedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'startDay': serializer.toJson<int>(startDay),
      'reason': serializer.toJson<String>(reason),
      'decidedAt': serializer.toJson<DateTime>(decidedAt),
    };
  }

  DeloadRow copyWith({int? startDay, String? reason, DateTime? decidedAt}) =>
      DeloadRow(
        startDay: startDay ?? this.startDay,
        reason: reason ?? this.reason,
        decidedAt: decidedAt ?? this.decidedAt,
      );
  DeloadRow copyWithCompanion(DeloadsCompanion data) {
    return DeloadRow(
      startDay: data.startDay.present ? data.startDay.value : this.startDay,
      reason: data.reason.present ? data.reason.value : this.reason,
      decidedAt: data.decidedAt.present ? data.decidedAt.value : this.decidedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeloadRow(')
          ..write('startDay: $startDay, ')
          ..write('reason: $reason, ')
          ..write('decidedAt: $decidedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(startDay, reason, decidedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeloadRow &&
          other.startDay == this.startDay &&
          other.reason == this.reason &&
          other.decidedAt == this.decidedAt);
}

class DeloadsCompanion extends UpdateCompanion<DeloadRow> {
  final Value<int> startDay;
  final Value<String> reason;
  final Value<DateTime> decidedAt;
  const DeloadsCompanion({
    this.startDay = const Value.absent(),
    this.reason = const Value.absent(),
    this.decidedAt = const Value.absent(),
  });
  DeloadsCompanion.insert({
    this.startDay = const Value.absent(),
    required String reason,
    required DateTime decidedAt,
  }) : reason = Value(reason),
       decidedAt = Value(decidedAt);
  static Insertable<DeloadRow> custom({
    Expression<int>? startDay,
    Expression<String>? reason,
    Expression<DateTime>? decidedAt,
  }) {
    return RawValuesInsertable({
      if (startDay != null) 'start_day': startDay,
      if (reason != null) 'reason': reason,
      if (decidedAt != null) 'decided_at': decidedAt,
    });
  }

  DeloadsCompanion copyWith({
    Value<int>? startDay,
    Value<String>? reason,
    Value<DateTime>? decidedAt,
  }) {
    return DeloadsCompanion(
      startDay: startDay ?? this.startDay,
      reason: reason ?? this.reason,
      decidedAt: decidedAt ?? this.decidedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (startDay.present) {
      map['start_day'] = Variable<int>(startDay.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (decidedAt.present) {
      map['decided_at'] = Variable<DateTime>(decidedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeloadsCompanion(')
          ..write('startDay: $startDay, ')
          ..write('reason: $reason, ')
          ..write('decidedAt: $decidedAt')
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
  late final $WorkoutSessionsTable workoutSessions = $WorkoutSessionsTable(
    this,
  );
  late final $WorkoutSetsTable workoutSets = $WorkoutSetsTable(this);
  late final $MemoryDocumentsTable memoryDocuments = $MemoryDocumentsTable(
    this,
  );
  late final $MemoryChunksTable memoryChunks = $MemoryChunksTable(this);
  late final $MealsTable meals = $MealsTable(this);
  late final $FoodLogEntriesTable foodLogEntries = $FoodLogEntriesTable(this);
  late final $AiCallsTable aiCalls = $AiCallsTable(this);
  late final $AiCacheEntriesTable aiCacheEntries = $AiCacheEntriesTable(this);
  late final $BodyMeasurementsTable bodyMeasurements = $BodyMeasurementsTable(
    this,
  );
  late final $BodySegmentsTable bodySegments = $BodySegmentsTable(this);
  late final $LabResultsTable labResults = $LabResultsTable(this);
  late final $HealthDaysTable healthDays = $HealthDaysTable(this);
  late final $WeeklyReviewsTable weeklyReviews = $WeeklyReviewsTable(this);
  late final $DeloadsTable deloads = $DeloadsTable(this);
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
    workoutSessions,
    workoutSets,
    memoryDocuments,
    memoryChunks,
    meals,
    foodLogEntries,
    aiCalls,
    aiCacheEntries,
    bodyMeasurements,
    bodySegments,
    labResults,
    healthDays,
    weeklyReviews,
    deloads,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workout_sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('workout_sets', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'memory_documents',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('memory_chunks', kind: UpdateKind.delete)],
    ),
  ]);
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
  Value<int> bonusXp,
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
  Value<int> bonusXp,
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

  ColumnFilters<int> get bonusXp => $composableBuilder(
    column: $table.bonusXp,
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

  ColumnOrderings<int> get bonusXp => $composableBuilder(
    column: $table.bonusXp,
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

  GeneratedColumn<int> get bonusXp =>
      $composableBuilder(column: $table.bonusXp, builder: (column) => column);

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
                Value<int> bonusXp = const Value.absent(),
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
                bonusXp: bonusXp,
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
                Value<int> bonusXp = const Value.absent(),
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
                bonusXp: bonusXp,
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
      Value<int> questsCleared,
      Value<int?> lastActiveDay,
      Value<int?> programmeStartDay,
      Value<int> acknowledgedLevel,
      Value<String> themeMode,
      Value<String> acknowledgedRank,
      Value<String> acknowledgedMedals,
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
      Value<int> questsCleared,
      Value<int?> lastActiveDay,
      Value<int?> programmeStartDay,
      Value<int> acknowledgedLevel,
      Value<String> themeMode,
      Value<String> acknowledgedRank,
      Value<String> acknowledgedMedals,
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

  ColumnFilters<int> get questsCleared => $composableBuilder(
    column: $table.questsCleared,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastActiveDay => $composableBuilder(
    column: $table.lastActiveDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get programmeStartDay => $composableBuilder(
    column: $table.programmeStartDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get acknowledgedLevel => $composableBuilder(
    column: $table.acknowledgedLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get acknowledgedRank => $composableBuilder(
    column: $table.acknowledgedRank,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get acknowledgedMedals => $composableBuilder(
    column: $table.acknowledgedMedals,
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

  ColumnOrderings<int> get questsCleared => $composableBuilder(
    column: $table.questsCleared,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastActiveDay => $composableBuilder(
    column: $table.lastActiveDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get programmeStartDay => $composableBuilder(
    column: $table.programmeStartDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get acknowledgedLevel => $composableBuilder(
    column: $table.acknowledgedLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get acknowledgedRank => $composableBuilder(
    column: $table.acknowledgedRank,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get acknowledgedMedals => $composableBuilder(
    column: $table.acknowledgedMedals,
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

  GeneratedColumn<int> get questsCleared => $composableBuilder(
    column: $table.questsCleared,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastActiveDay => $composableBuilder(
    column: $table.lastActiveDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get programmeStartDay => $composableBuilder(
    column: $table.programmeStartDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get acknowledgedLevel => $composableBuilder(
    column: $table.acknowledgedLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<String> get acknowledgedRank => $composableBuilder(
    column: $table.acknowledgedRank,
    builder: (column) => column,
  );

  GeneratedColumn<String> get acknowledgedMedals => $composableBuilder(
    column: $table.acknowledgedMedals,
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
                Value<int> questsCleared = const Value.absent(),
                Value<int?> lastActiveDay = const Value.absent(),
                Value<int?> programmeStartDay = const Value.absent(),
                Value<int> acknowledgedLevel = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<String> acknowledgedRank = const Value.absent(),
                Value<String> acknowledgedMedals = const Value.absent(),
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
                questsCleared: questsCleared,
                lastActiveDay: lastActiveDay,
                programmeStartDay: programmeStartDay,
                acknowledgedLevel: acknowledgedLevel,
                themeMode: themeMode,
                acknowledgedRank: acknowledgedRank,
                acknowledgedMedals: acknowledgedMedals,
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
                Value<int> questsCleared = const Value.absent(),
                Value<int?> lastActiveDay = const Value.absent(),
                Value<int?> programmeStartDay = const Value.absent(),
                Value<int> acknowledgedLevel = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<String> acknowledgedRank = const Value.absent(),
                Value<String> acknowledgedMedals = const Value.absent(),
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
                questsCleared: questsCleared,
                lastActiveDay: lastActiveDay,
                programmeStartDay: programmeStartDay,
                acknowledgedLevel: acknowledgedLevel,
                themeMode: themeMode,
                acknowledgedRank: acknowledgedRank,
                acknowledgedMedals: acknowledgedMedals,
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
typedef $$WorkoutSessionsTableCreateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      Value<int> id,
      required int day,
      required TrainingPhase phase,
      required int week,
      required String focus,
      Value<String?> notes,
      Value<TrainerNoteSource> noteSource,
      Value<DateTime?> summonedAt,
      Value<DateTime?> startedAt,
      Value<DateTime?> completedAt,
    });
typedef $$WorkoutSessionsTableUpdateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      Value<int> id,
      Value<int> day,
      Value<TrainingPhase> phase,
      Value<int> week,
      Value<String> focus,
      Value<String?> notes,
      Value<TrainerNoteSource> noteSource,
      Value<DateTime?> summonedAt,
      Value<DateTime?> startedAt,
      Value<DateTime?> completedAt,
    });

final class $$WorkoutSessionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WorkoutSessionsTable,
          WorkoutSessionRow
        > {
  $$WorkoutSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$WorkoutSetsTable, List<WorkoutSetRow>>
  _workoutSetsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutSets,
    aliasName: 'workout_sessions__id__workout_sets__session_id',
  );

  $$WorkoutSetsTableProcessedTableManager get workoutSetsRefs {
    final manager = $$WorkoutSetsTableTableManager(
      $_db,
      $_db.workoutSets,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_workoutSetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableFilterComposer({
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

  ColumnWithTypeConverterFilters<TrainingPhase, TrainingPhase, String>
  get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get week => $composableBuilder(
    column: $table.week,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get focus => $composableBuilder(
    column: $table.focus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TrainerNoteSource, TrainerNoteSource, String>
  get noteSource => $composableBuilder(
    column: $table.noteSource,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get summonedAt => $composableBuilder(
    column: $table.summonedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> workoutSetsRefs(
    Expression<bool> Function($$WorkoutSetsTableFilterComposer f) f,
  ) {
    final $$WorkoutSetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableOrderingComposer({
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

  ColumnOrderings<String> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get week => $composableBuilder(
    column: $table.week,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get focus => $composableBuilder(
    column: $table.focus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get noteSource => $composableBuilder(
    column: $table.noteSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get summonedAt => $composableBuilder(
    column: $table.summonedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableAnnotationComposer({
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

  GeneratedColumnWithTypeConverter<TrainingPhase, String> get phase =>
      $composableBuilder(column: $table.phase, builder: (column) => column);

  GeneratedColumn<int> get week =>
      $composableBuilder(column: $table.week, builder: (column) => column);

  GeneratedColumn<String> get focus =>
      $composableBuilder(column: $table.focus, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TrainerNoteSource, String> get noteSource =>
      $composableBuilder(
        column: $table.noteSource,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get summonedAt => $composableBuilder(
    column: $table.summonedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  Expression<T> workoutSetsRefs<T extends Object>(
    Expression<T> Function($$WorkoutSetsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutSetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSessionsTable,
          WorkoutSessionRow,
          $$WorkoutSessionsTableFilterComposer,
          $$WorkoutSessionsTableOrderingComposer,
          $$WorkoutSessionsTableAnnotationComposer,
          $$WorkoutSessionsTableCreateCompanionBuilder,
          $$WorkoutSessionsTableUpdateCompanionBuilder,
          (WorkoutSessionRow, $$WorkoutSessionsTableReferences),
          WorkoutSessionRow,
          PrefetchHooks Function({bool workoutSetsRefs})
        > {
  $$WorkoutSessionsTableTableManager(
    _$AppDatabase db,
    $WorkoutSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> day = const Value.absent(),
                Value<TrainingPhase> phase = const Value.absent(),
                Value<int> week = const Value.absent(),
                Value<String> focus = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<TrainerNoteSource> noteSource = const Value.absent(),
                Value<DateTime?> summonedAt = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
              }) => WorkoutSessionsCompanion(
                id: id,
                day: day,
                phase: phase,
                week: week,
                focus: focus,
                notes: notes,
                noteSource: noteSource,
                summonedAt: summonedAt,
                startedAt: startedAt,
                completedAt: completedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int day,
                required TrainingPhase phase,
                required int week,
                required String focus,
                Value<String?> notes = const Value.absent(),
                Value<TrainerNoteSource> noteSource = const Value.absent(),
                Value<DateTime?> summonedAt = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
              }) => WorkoutSessionsCompanion.insert(
                id: id,
                day: day,
                phase: phase,
                week: week,
                focus: focus,
                notes: notes,
                noteSource: noteSource,
                summonedAt: summonedAt,
                startedAt: startedAt,
                completedAt: completedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkoutSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workoutSetsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (workoutSetsRefs) db.workoutSets],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (workoutSetsRefs)
                    await $_getPrefetchedData<
                      WorkoutSessionRow,
                      $WorkoutSessionsTable,
                      WorkoutSetRow
                    >(
                      currentTable: table,
                      referencedTable: $$WorkoutSessionsTableReferences
                          ._workoutSetsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$WorkoutSessionsTableReferences(
                            db,
                            table,
                            p0,
                          ).workoutSetsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.sessionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSessionsTable,
      WorkoutSessionRow,
      $$WorkoutSessionsTableFilterComposer,
      $$WorkoutSessionsTableOrderingComposer,
      $$WorkoutSessionsTableAnnotationComposer,
      $$WorkoutSessionsTableCreateCompanionBuilder,
      $$WorkoutSessionsTableUpdateCompanionBuilder,
      (WorkoutSessionRow, $$WorkoutSessionsTableReferences),
      WorkoutSessionRow,
      PrefetchHooks Function({bool workoutSetsRefs})
    >;
typedef $$WorkoutSetsTableCreateCompanionBuilder =
    WorkoutSetsCompanion Function({
      Value<int> id,
      required int sessionId,
      required String exerciseId,
      required int orderIndex,
      required int setIndex,
      required int target,
      Value<int?> actual,
      Value<int?> loadHalfKg,
      Value<bool> done,
      Value<DateTime?> completedAt,
      Value<bool> isExtra,
    });
typedef $$WorkoutSetsTableUpdateCompanionBuilder =
    WorkoutSetsCompanion Function({
      Value<int> id,
      Value<int> sessionId,
      Value<String> exerciseId,
      Value<int> orderIndex,
      Value<int> setIndex,
      Value<int> target,
      Value<int?> actual,
      Value<int?> loadHalfKg,
      Value<bool> done,
      Value<DateTime?> completedAt,
      Value<bool> isExtra,
    });

final class $$WorkoutSetsTableReferences
    extends BaseReferences<_$AppDatabase, $WorkoutSetsTable, WorkoutSetRow> {
  $$WorkoutSetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutSessionsTable _sessionIdTable(_$AppDatabase db) => db
      .workoutSessions
      .createAlias('workout_sets__session_id__workout_sessions__id');

  $$WorkoutSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$WorkoutSessionsTableTableManager(
      $_db,
      $_db.workoutSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WorkoutSetsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableFilterComposer({
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

  ColumnFilters<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get setIndex => $composableBuilder(
    column: $table.setIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get actual => $composableBuilder(
    column: $table.actual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get loadHalfKg => $composableBuilder(
    column: $table.loadHalfKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isExtra => $composableBuilder(
    column: $table.isExtra,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutSessionsTableFilterComposer get sessionId {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableOrderingComposer({
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

  ColumnOrderings<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get setIndex => $composableBuilder(
    column: $table.setIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get actual => $composableBuilder(
    column: $table.actual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get loadHalfKg => $composableBuilder(
    column: $table.loadHalfKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isExtra => $composableBuilder(
    column: $table.isExtra,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutSessionsTableOrderingComposer get sessionId {
    final $$WorkoutSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get setIndex =>
      $composableBuilder(column: $table.setIndex, builder: (column) => column);

  GeneratedColumn<int> get target =>
      $composableBuilder(column: $table.target, builder: (column) => column);

  GeneratedColumn<int> get actual =>
      $composableBuilder(column: $table.actual, builder: (column) => column);

  GeneratedColumn<int> get loadHalfKg => $composableBuilder(
    column: $table.loadHalfKg,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isExtra =>
      $composableBuilder(column: $table.isExtra, builder: (column) => column);

  $$WorkoutSessionsTableAnnotationComposer get sessionId {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSetsTable,
          WorkoutSetRow,
          $$WorkoutSetsTableFilterComposer,
          $$WorkoutSetsTableOrderingComposer,
          $$WorkoutSetsTableAnnotationComposer,
          $$WorkoutSetsTableCreateCompanionBuilder,
          $$WorkoutSetsTableUpdateCompanionBuilder,
          (WorkoutSetRow, $$WorkoutSetsTableReferences),
          WorkoutSetRow,
          PrefetchHooks Function({bool sessionId})
        > {
  $$WorkoutSetsTableTableManager(_$AppDatabase db, $WorkoutSetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<int> setIndex = const Value.absent(),
                Value<int> target = const Value.absent(),
                Value<int?> actual = const Value.absent(),
                Value<int?> loadHalfKg = const Value.absent(),
                Value<bool> done = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<bool> isExtra = const Value.absent(),
              }) => WorkoutSetsCompanion(
                id: id,
                sessionId: sessionId,
                exerciseId: exerciseId,
                orderIndex: orderIndex,
                setIndex: setIndex,
                target: target,
                actual: actual,
                loadHalfKg: loadHalfKg,
                done: done,
                completedAt: completedAt,
                isExtra: isExtra,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                required String exerciseId,
                required int orderIndex,
                required int setIndex,
                required int target,
                Value<int?> actual = const Value.absent(),
                Value<int?> loadHalfKg = const Value.absent(),
                Value<bool> done = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<bool> isExtra = const Value.absent(),
              }) => WorkoutSetsCompanion.insert(
                id: id,
                sessionId: sessionId,
                exerciseId: exerciseId,
                orderIndex: orderIndex,
                setIndex: setIndex,
                target: target,
                actual: actual,
                loadHalfKg: loadHalfKg,
                done: done,
                completedAt: completedAt,
                isExtra: isExtra,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkoutSetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
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
                    if (sessionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sessionId,
                        referencedTable: $$WorkoutSetsTableReferences
                            ._sessionIdTable(db),
                        referencedColumn: $$WorkoutSetsTableReferences
                            ._sessionIdTable(db)
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

typedef $$WorkoutSetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSetsTable,
      WorkoutSetRow,
      $$WorkoutSetsTableFilterComposer,
      $$WorkoutSetsTableOrderingComposer,
      $$WorkoutSetsTableAnnotationComposer,
      $$WorkoutSetsTableCreateCompanionBuilder,
      $$WorkoutSetsTableUpdateCompanionBuilder,
      (WorkoutSetRow, $$WorkoutSetsTableReferences),
      WorkoutSetRow,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$MemoryDocumentsTableCreateCompanionBuilder =
    MemoryDocumentsCompanion Function({
      Value<int> id,
      required MemoryKind kind,
      required String title,
      required String body,
      Value<int?> day,
      required DateTime createdAt,
      Value<String?> sourcePath,
      Value<String?> externalId,
    });
typedef $$MemoryDocumentsTableUpdateCompanionBuilder =
    MemoryDocumentsCompanion Function({
      Value<int> id,
      Value<MemoryKind> kind,
      Value<String> title,
      Value<String> body,
      Value<int?> day,
      Value<DateTime> createdAt,
      Value<String?> sourcePath,
      Value<String?> externalId,
    });

final class $$MemoryDocumentsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MemoryDocumentsTable,
          MemoryDocumentRow
        > {
  $$MemoryDocumentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$MemoryChunksTable, List<MemoryChunkRow>>
  _memoryChunksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.memoryChunks,
    aliasName: 'memory_documents__id__memory_chunks__document_id',
  );

  $$MemoryChunksTableProcessedTableManager get memoryChunksRefs {
    final manager = $$MemoryChunksTableTableManager(
      $_db,
      $_db.memoryChunks,
    ).filter((f) => f.documentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_memoryChunksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MemoryDocumentsTableFilterComposer
    extends Composer<_$AppDatabase, $MemoryDocumentsTable> {
  $$MemoryDocumentsTableFilterComposer({
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

  ColumnWithTypeConverterFilters<MemoryKind, MemoryKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourcePath => $composableBuilder(
    column: $table.sourcePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> memoryChunksRefs(
    Expression<bool> Function($$MemoryChunksTableFilterComposer f) f,
  ) {
    final $$MemoryChunksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memoryChunks,
      getReferencedColumn: (t) => t.documentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemoryChunksTableFilterComposer(
            $db: $db,
            $table: $db.memoryChunks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MemoryDocumentsTableOrderingComposer
    extends Composer<_$AppDatabase, $MemoryDocumentsTable> {
  $$MemoryDocumentsTableOrderingComposer({
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

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourcePath => $composableBuilder(
    column: $table.sourcePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MemoryDocumentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MemoryDocumentsTable> {
  $$MemoryDocumentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MemoryKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<int> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get sourcePath => $composableBuilder(
    column: $table.sourcePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => column,
  );

  Expression<T> memoryChunksRefs<T extends Object>(
    Expression<T> Function($$MemoryChunksTableAnnotationComposer a) f,
  ) {
    final $$MemoryChunksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memoryChunks,
      getReferencedColumn: (t) => t.documentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemoryChunksTableAnnotationComposer(
            $db: $db,
            $table: $db.memoryChunks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MemoryDocumentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MemoryDocumentsTable,
          MemoryDocumentRow,
          $$MemoryDocumentsTableFilterComposer,
          $$MemoryDocumentsTableOrderingComposer,
          $$MemoryDocumentsTableAnnotationComposer,
          $$MemoryDocumentsTableCreateCompanionBuilder,
          $$MemoryDocumentsTableUpdateCompanionBuilder,
          (MemoryDocumentRow, $$MemoryDocumentsTableReferences),
          MemoryDocumentRow,
          PrefetchHooks Function({bool memoryChunksRefs})
        > {
  $$MemoryDocumentsTableTableManager(
    _$AppDatabase db,
    $MemoryDocumentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemoryDocumentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemoryDocumentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MemoryDocumentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<MemoryKind> kind = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<int?> day = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> sourcePath = const Value.absent(),
                Value<String?> externalId = const Value.absent(),
              }) => MemoryDocumentsCompanion(
                id: id,
                kind: kind,
                title: title,
                body: body,
                day: day,
                createdAt: createdAt,
                sourcePath: sourcePath,
                externalId: externalId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required MemoryKind kind,
                required String title,
                required String body,
                Value<int?> day = const Value.absent(),
                required DateTime createdAt,
                Value<String?> sourcePath = const Value.absent(),
                Value<String?> externalId = const Value.absent(),
              }) => MemoryDocumentsCompanion.insert(
                id: id,
                kind: kind,
                title: title,
                body: body,
                day: day,
                createdAt: createdAt,
                sourcePath: sourcePath,
                externalId: externalId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MemoryDocumentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({memoryChunksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (memoryChunksRefs) db.memoryChunks],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (memoryChunksRefs)
                    await $_getPrefetchedData<
                      MemoryDocumentRow,
                      $MemoryDocumentsTable,
                      MemoryChunkRow
                    >(
                      currentTable: table,
                      referencedTable: $$MemoryDocumentsTableReferences
                          ._memoryChunksRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$MemoryDocumentsTableReferences(
                            db,
                            table,
                            p0,
                          ).memoryChunksRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.documentId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MemoryDocumentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MemoryDocumentsTable,
      MemoryDocumentRow,
      $$MemoryDocumentsTableFilterComposer,
      $$MemoryDocumentsTableOrderingComposer,
      $$MemoryDocumentsTableAnnotationComposer,
      $$MemoryDocumentsTableCreateCompanionBuilder,
      $$MemoryDocumentsTableUpdateCompanionBuilder,
      (MemoryDocumentRow, $$MemoryDocumentsTableReferences),
      MemoryDocumentRow,
      PrefetchHooks Function({bool memoryChunksRefs})
    >;
typedef $$MemoryChunksTableCreateCompanionBuilder =
    MemoryChunksCompanion Function({
      Value<int> id,
      required int documentId,
      required int chunkIndex,
      required String content,
      required Uint8List embedding,
      required int dimensions,
      required String embedder,
    });
typedef $$MemoryChunksTableUpdateCompanionBuilder =
    MemoryChunksCompanion Function({
      Value<int> id,
      Value<int> documentId,
      Value<int> chunkIndex,
      Value<String> content,
      Value<Uint8List> embedding,
      Value<int> dimensions,
      Value<String> embedder,
    });

final class $$MemoryChunksTableReferences
    extends BaseReferences<_$AppDatabase, $MemoryChunksTable, MemoryChunkRow> {
  $$MemoryChunksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MemoryDocumentsTable _documentIdTable(_$AppDatabase db) => db
      .memoryDocuments
      .createAlias('memory_chunks__document_id__memory_documents__id');

  $$MemoryDocumentsTableProcessedTableManager get documentId {
    final $_column = $_itemColumn<int>('document_id')!;

    final manager = $$MemoryDocumentsTableTableManager(
      $_db,
      $_db.memoryDocuments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_documentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MemoryChunksTableFilterComposer
    extends Composer<_$AppDatabase, $MemoryChunksTable> {
  $$MemoryChunksTableFilterComposer({
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

  ColumnFilters<int> get chunkIndex => $composableBuilder(
    column: $table.chunkIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get embedding => $composableBuilder(
    column: $table.embedding,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dimensions => $composableBuilder(
    column: $table.dimensions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get embedder => $composableBuilder(
    column: $table.embedder,
    builder: (column) => ColumnFilters(column),
  );

  $$MemoryDocumentsTableFilterComposer get documentId {
    final $$MemoryDocumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.memoryDocuments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemoryDocumentsTableFilterComposer(
            $db: $db,
            $table: $db.memoryDocuments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemoryChunksTableOrderingComposer
    extends Composer<_$AppDatabase, $MemoryChunksTable> {
  $$MemoryChunksTableOrderingComposer({
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

  ColumnOrderings<int> get chunkIndex => $composableBuilder(
    column: $table.chunkIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get embedding => $composableBuilder(
    column: $table.embedding,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dimensions => $composableBuilder(
    column: $table.dimensions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get embedder => $composableBuilder(
    column: $table.embedder,
    builder: (column) => ColumnOrderings(column),
  );

  $$MemoryDocumentsTableOrderingComposer get documentId {
    final $$MemoryDocumentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.memoryDocuments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemoryDocumentsTableOrderingComposer(
            $db: $db,
            $table: $db.memoryDocuments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemoryChunksTableAnnotationComposer
    extends Composer<_$AppDatabase, $MemoryChunksTable> {
  $$MemoryChunksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get chunkIndex => $composableBuilder(
    column: $table.chunkIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<Uint8List> get embedding =>
      $composableBuilder(column: $table.embedding, builder: (column) => column);

  GeneratedColumn<int> get dimensions => $composableBuilder(
    column: $table.dimensions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get embedder =>
      $composableBuilder(column: $table.embedder, builder: (column) => column);

  $$MemoryDocumentsTableAnnotationComposer get documentId {
    final $$MemoryDocumentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.memoryDocuments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemoryDocumentsTableAnnotationComposer(
            $db: $db,
            $table: $db.memoryDocuments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemoryChunksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MemoryChunksTable,
          MemoryChunkRow,
          $$MemoryChunksTableFilterComposer,
          $$MemoryChunksTableOrderingComposer,
          $$MemoryChunksTableAnnotationComposer,
          $$MemoryChunksTableCreateCompanionBuilder,
          $$MemoryChunksTableUpdateCompanionBuilder,
          (MemoryChunkRow, $$MemoryChunksTableReferences),
          MemoryChunkRow,
          PrefetchHooks Function({bool documentId})
        > {
  $$MemoryChunksTableTableManager(_$AppDatabase db, $MemoryChunksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemoryChunksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemoryChunksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MemoryChunksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> documentId = const Value.absent(),
                Value<int> chunkIndex = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<Uint8List> embedding = const Value.absent(),
                Value<int> dimensions = const Value.absent(),
                Value<String> embedder = const Value.absent(),
              }) => MemoryChunksCompanion(
                id: id,
                documentId: documentId,
                chunkIndex: chunkIndex,
                content: content,
                embedding: embedding,
                dimensions: dimensions,
                embedder: embedder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int documentId,
                required int chunkIndex,
                required String content,
                required Uint8List embedding,
                required int dimensions,
                required String embedder,
              }) => MemoryChunksCompanion.insert(
                id: id,
                documentId: documentId,
                chunkIndex: chunkIndex,
                content: content,
                embedding: embedding,
                dimensions: dimensions,
                embedder: embedder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MemoryChunksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({documentId = false}) {
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
                    if (documentId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.documentId,
                        referencedTable: $$MemoryChunksTableReferences
                            ._documentIdTable(db),
                        referencedColumn: $$MemoryChunksTableReferences
                            ._documentIdTable(db)
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

typedef $$MemoryChunksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MemoryChunksTable,
      MemoryChunkRow,
      $$MemoryChunksTableFilterComposer,
      $$MemoryChunksTableOrderingComposer,
      $$MemoryChunksTableAnnotationComposer,
      $$MemoryChunksTableCreateCompanionBuilder,
      $$MemoryChunksTableUpdateCompanionBuilder,
      (MemoryChunkRow, $$MemoryChunksTableReferences),
      MemoryChunkRow,
      PrefetchHooks Function({bool documentId})
    >;
typedef $$MealsTableCreateCompanionBuilder = MealsCompanion Function({
  required String id,
  required String name,
  required MealSlot slot,
  Value<List<int>> daysOfWeek,
  required int kcal,
  required double proteinG,
  required double carbsG,
  required double fatG,
  required double fibreG,
  required String detail,
  Value<bool> isActive,
  Value<int> rowid,
});
typedef $$MealsTableUpdateCompanionBuilder = MealsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<MealSlot> slot,
  Value<List<int>> daysOfWeek,
  Value<int> kcal,
  Value<double> proteinG,
  Value<double> carbsG,
  Value<double> fatG,
  Value<double> fibreG,
  Value<String> detail,
  Value<bool> isActive,
  Value<int> rowid,
});

class $$MealsTableFilterComposer extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MealSlot, MealSlot, String> get slot =>
      $composableBuilder(
        column: $table.slot,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<List<int>, List<int>, String> get daysOfWeek =>
      $composableBuilder(
        column: $table.daysOfWeek,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get kcal => $composableBuilder(
    column: $table.kcal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinG => $composableBuilder(
    column: $table.proteinG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbsG => $composableBuilder(
    column: $table.carbsG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatG => $composableBuilder(
    column: $table.fatG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fibreG => $composableBuilder(
    column: $table.fibreG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detail => $composableBuilder(
    column: $table.detail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MealsTableOrderingComposer
    extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slot => $composableBuilder(
    column: $table.slot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get daysOfWeek => $composableBuilder(
    column: $table.daysOfWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get kcal => $composableBuilder(
    column: $table.kcal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinG => $composableBuilder(
    column: $table.proteinG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbsG => $composableBuilder(
    column: $table.carbsG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatG => $composableBuilder(
    column: $table.fatG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fibreG => $composableBuilder(
    column: $table.fibreG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detail => $composableBuilder(
    column: $table.detail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MealsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MealSlot, String> get slot =>
      $composableBuilder(column: $table.slot, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<int>, String> get daysOfWeek =>
      $composableBuilder(
        column: $table.daysOfWeek,
        builder: (column) => column,
      );

  GeneratedColumn<int> get kcal =>
      $composableBuilder(column: $table.kcal, builder: (column) => column);

  GeneratedColumn<double> get proteinG =>
      $composableBuilder(column: $table.proteinG, builder: (column) => column);

  GeneratedColumn<double> get carbsG =>
      $composableBuilder(column: $table.carbsG, builder: (column) => column);

  GeneratedColumn<double> get fatG =>
      $composableBuilder(column: $table.fatG, builder: (column) => column);

  GeneratedColumn<double> get fibreG =>
      $composableBuilder(column: $table.fibreG, builder: (column) => column);

  GeneratedColumn<String> get detail =>
      $composableBuilder(column: $table.detail, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$MealsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealsTable,
          MealRow,
          $$MealsTableFilterComposer,
          $$MealsTableOrderingComposer,
          $$MealsTableAnnotationComposer,
          $$MealsTableCreateCompanionBuilder,
          $$MealsTableUpdateCompanionBuilder,
          (MealRow, BaseReferences<_$AppDatabase, $MealsTable, MealRow>),
          MealRow,
          PrefetchHooks Function()
        > {
  $$MealsTableTableManager(_$AppDatabase db, $MealsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<MealSlot> slot = const Value.absent(),
                Value<List<int>> daysOfWeek = const Value.absent(),
                Value<int> kcal = const Value.absent(),
                Value<double> proteinG = const Value.absent(),
                Value<double> carbsG = const Value.absent(),
                Value<double> fatG = const Value.absent(),
                Value<double> fibreG = const Value.absent(),
                Value<String> detail = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MealsCompanion(
                id: id,
                name: name,
                slot: slot,
                daysOfWeek: daysOfWeek,
                kcal: kcal,
                proteinG: proteinG,
                carbsG: carbsG,
                fatG: fatG,
                fibreG: fibreG,
                detail: detail,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required MealSlot slot,
                Value<List<int>> daysOfWeek = const Value.absent(),
                required int kcal,
                required double proteinG,
                required double carbsG,
                required double fatG,
                required double fibreG,
                required String detail,
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MealsCompanion.insert(
                id: id,
                name: name,
                slot: slot,
                daysOfWeek: daysOfWeek,
                kcal: kcal,
                proteinG: proteinG,
                carbsG: carbsG,
                fatG: fatG,
                fibreG: fibreG,
                detail: detail,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MealsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealsTable,
      MealRow,
      $$MealsTableFilterComposer,
      $$MealsTableOrderingComposer,
      $$MealsTableAnnotationComposer,
      $$MealsTableCreateCompanionBuilder,
      $$MealsTableUpdateCompanionBuilder,
      (MealRow, BaseReferences<_$AppDatabase, $MealsTable, MealRow>),
      MealRow,
      PrefetchHooks Function()
    >;
typedef $$FoodLogEntriesTableCreateCompanionBuilder =
    FoodLogEntriesCompanion Function({
      Value<int> id,
      required int day,
      required MealSlot slot,
      required String body,
      required DateTime loggedAt,
      Value<MacroSource> macroSource,
      Value<double?> confidence,
      Value<int?> kcal,
      Value<double?> proteinG,
      Value<double?> carbsG,
      Value<double?> fatG,
      Value<double?> fibreG,
      Value<String?> items,
      Value<String?> analysisError,
    });
typedef $$FoodLogEntriesTableUpdateCompanionBuilder =
    FoodLogEntriesCompanion Function({
      Value<int> id,
      Value<int> day,
      Value<MealSlot> slot,
      Value<String> body,
      Value<DateTime> loggedAt,
      Value<MacroSource> macroSource,
      Value<double?> confidence,
      Value<int?> kcal,
      Value<double?> proteinG,
      Value<double?> carbsG,
      Value<double?> fatG,
      Value<double?> fibreG,
      Value<String?> items,
      Value<String?> analysisError,
    });

class $$FoodLogEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $FoodLogEntriesTable> {
  $$FoodLogEntriesTableFilterComposer({
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

  ColumnWithTypeConverterFilters<MealSlot, MealSlot, String> get slot =>
      $composableBuilder(
        column: $table.slot,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MacroSource, MacroSource, String>
  get macroSource => $composableBuilder(
    column: $table.macroSource,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get kcal => $composableBuilder(
    column: $table.kcal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinG => $composableBuilder(
    column: $table.proteinG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbsG => $composableBuilder(
    column: $table.carbsG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatG => $composableBuilder(
    column: $table.fatG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fibreG => $composableBuilder(
    column: $table.fibreG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get items => $composableBuilder(
    column: $table.items,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get analysisError => $composableBuilder(
    column: $table.analysisError,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FoodLogEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodLogEntriesTable> {
  $$FoodLogEntriesTableOrderingComposer({
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

  ColumnOrderings<String> get slot => $composableBuilder(
    column: $table.slot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get macroSource => $composableBuilder(
    column: $table.macroSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get kcal => $composableBuilder(
    column: $table.kcal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinG => $composableBuilder(
    column: $table.proteinG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbsG => $composableBuilder(
    column: $table.carbsG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatG => $composableBuilder(
    column: $table.fatG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fibreG => $composableBuilder(
    column: $table.fibreG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get items => $composableBuilder(
    column: $table.items,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get analysisError => $composableBuilder(
    column: $table.analysisError,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FoodLogEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodLogEntriesTable> {
  $$FoodLogEntriesTableAnnotationComposer({
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

  GeneratedColumnWithTypeConverter<MealSlot, String> get slot =>
      $composableBuilder(column: $table.slot, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MacroSource, String> get macroSource =>
      $composableBuilder(
        column: $table.macroSource,
        builder: (column) => column,
      );

  GeneratedColumn<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<int> get kcal =>
      $composableBuilder(column: $table.kcal, builder: (column) => column);

  GeneratedColumn<double> get proteinG =>
      $composableBuilder(column: $table.proteinG, builder: (column) => column);

  GeneratedColumn<double> get carbsG =>
      $composableBuilder(column: $table.carbsG, builder: (column) => column);

  GeneratedColumn<double> get fatG =>
      $composableBuilder(column: $table.fatG, builder: (column) => column);

  GeneratedColumn<double> get fibreG =>
      $composableBuilder(column: $table.fibreG, builder: (column) => column);

  GeneratedColumn<String> get items =>
      $composableBuilder(column: $table.items, builder: (column) => column);

  GeneratedColumn<String> get analysisError => $composableBuilder(
    column: $table.analysisError,
    builder: (column) => column,
  );
}

class $$FoodLogEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoodLogEntriesTable,
          FoodLogRow,
          $$FoodLogEntriesTableFilterComposer,
          $$FoodLogEntriesTableOrderingComposer,
          $$FoodLogEntriesTableAnnotationComposer,
          $$FoodLogEntriesTableCreateCompanionBuilder,
          $$FoodLogEntriesTableUpdateCompanionBuilder,
          (
            FoodLogRow,
            BaseReferences<_$AppDatabase, $FoodLogEntriesTable, FoodLogRow>,
          ),
          FoodLogRow,
          PrefetchHooks Function()
        > {
  $$FoodLogEntriesTableTableManager(
    _$AppDatabase db,
    $FoodLogEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodLogEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodLogEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodLogEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> day = const Value.absent(),
                Value<MealSlot> slot = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<DateTime> loggedAt = const Value.absent(),
                Value<MacroSource> macroSource = const Value.absent(),
                Value<double?> confidence = const Value.absent(),
                Value<int?> kcal = const Value.absent(),
                Value<double?> proteinG = const Value.absent(),
                Value<double?> carbsG = const Value.absent(),
                Value<double?> fatG = const Value.absent(),
                Value<double?> fibreG = const Value.absent(),
                Value<String?> items = const Value.absent(),
                Value<String?> analysisError = const Value.absent(),
              }) => FoodLogEntriesCompanion(
                id: id,
                day: day,
                slot: slot,
                body: body,
                loggedAt: loggedAt,
                macroSource: macroSource,
                confidence: confidence,
                kcal: kcal,
                proteinG: proteinG,
                carbsG: carbsG,
                fatG: fatG,
                fibreG: fibreG,
                items: items,
                analysisError: analysisError,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int day,
                required MealSlot slot,
                required String body,
                required DateTime loggedAt,
                Value<MacroSource> macroSource = const Value.absent(),
                Value<double?> confidence = const Value.absent(),
                Value<int?> kcal = const Value.absent(),
                Value<double?> proteinG = const Value.absent(),
                Value<double?> carbsG = const Value.absent(),
                Value<double?> fatG = const Value.absent(),
                Value<double?> fibreG = const Value.absent(),
                Value<String?> items = const Value.absent(),
                Value<String?> analysisError = const Value.absent(),
              }) => FoodLogEntriesCompanion.insert(
                id: id,
                day: day,
                slot: slot,
                body: body,
                loggedAt: loggedAt,
                macroSource: macroSource,
                confidence: confidence,
                kcal: kcal,
                proteinG: proteinG,
                carbsG: carbsG,
                fatG: fatG,
                fibreG: fibreG,
                items: items,
                analysisError: analysisError,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FoodLogEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoodLogEntriesTable,
      FoodLogRow,
      $$FoodLogEntriesTableFilterComposer,
      $$FoodLogEntriesTableOrderingComposer,
      $$FoodLogEntriesTableAnnotationComposer,
      $$FoodLogEntriesTableCreateCompanionBuilder,
      $$FoodLogEntriesTableUpdateCompanionBuilder,
      (
        FoodLogRow,
        BaseReferences<_$AppDatabase, $FoodLogEntriesTable, FoodLogRow>,
      ),
      FoodLogRow,
      PrefetchHooks Function()
    >;
typedef $$AiCallsTableCreateCompanionBuilder = AiCallsCompanion Function({
  Value<int> id,
  required DateTime at,
  required String lane,
  required String model,
  required bool ok,
  Value<bool> cached,
  Value<int> durationMs,
  Value<int> promptChars,
  Value<int> responseChars,
  Value<String?> error,
});
typedef $$AiCallsTableUpdateCompanionBuilder = AiCallsCompanion Function({
  Value<int> id,
  Value<DateTime> at,
  Value<String> lane,
  Value<String> model,
  Value<bool> ok,
  Value<bool> cached,
  Value<int> durationMs,
  Value<int> promptChars,
  Value<int> responseChars,
  Value<String?> error,
});

class $$AiCallsTableFilterComposer
    extends Composer<_$AppDatabase, $AiCallsTable> {
  $$AiCallsTableFilterComposer({
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

  ColumnFilters<String> get lane => $composableBuilder(
    column: $table.lane,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ok => $composableBuilder(
    column: $table.ok,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get cached => $composableBuilder(
    column: $table.cached,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get promptChars => $composableBuilder(
    column: $table.promptChars,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get responseChars => $composableBuilder(
    column: $table.responseChars,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AiCallsTableOrderingComposer
    extends Composer<_$AppDatabase, $AiCallsTable> {
  $$AiCallsTableOrderingComposer({
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

  ColumnOrderings<String> get lane => $composableBuilder(
    column: $table.lane,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ok => $composableBuilder(
    column: $table.ok,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get cached => $composableBuilder(
    column: $table.cached,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get promptChars => $composableBuilder(
    column: $table.promptChars,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get responseChars => $composableBuilder(
    column: $table.responseChars,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AiCallsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AiCallsTable> {
  $$AiCallsTableAnnotationComposer({
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

  GeneratedColumn<String> get lane =>
      $composableBuilder(column: $table.lane, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<bool> get ok =>
      $composableBuilder(column: $table.ok, builder: (column) => column);

  GeneratedColumn<bool> get cached =>
      $composableBuilder(column: $table.cached, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get promptChars => $composableBuilder(
    column: $table.promptChars,
    builder: (column) => column,
  );

  GeneratedColumn<int> get responseChars => $composableBuilder(
    column: $table.responseChars,
    builder: (column) => column,
  );

  GeneratedColumn<String> get error =>
      $composableBuilder(column: $table.error, builder: (column) => column);
}

class $$AiCallsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AiCallsTable,
          AiCallRow,
          $$AiCallsTableFilterComposer,
          $$AiCallsTableOrderingComposer,
          $$AiCallsTableAnnotationComposer,
          $$AiCallsTableCreateCompanionBuilder,
          $$AiCallsTableUpdateCompanionBuilder,
          (AiCallRow, BaseReferences<_$AppDatabase, $AiCallsTable, AiCallRow>),
          AiCallRow,
          PrefetchHooks Function()
        > {
  $$AiCallsTableTableManager(_$AppDatabase db, $AiCallsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiCallsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiCallsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AiCallsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                Value<String> lane = const Value.absent(),
                Value<String> model = const Value.absent(),
                Value<bool> ok = const Value.absent(),
                Value<bool> cached = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
                Value<int> promptChars = const Value.absent(),
                Value<int> responseChars = const Value.absent(),
                Value<String?> error = const Value.absent(),
              }) => AiCallsCompanion(
                id: id,
                at: at,
                lane: lane,
                model: model,
                ok: ok,
                cached: cached,
                durationMs: durationMs,
                promptChars: promptChars,
                responseChars: responseChars,
                error: error,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime at,
                required String lane,
                required String model,
                required bool ok,
                Value<bool> cached = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
                Value<int> promptChars = const Value.absent(),
                Value<int> responseChars = const Value.absent(),
                Value<String?> error = const Value.absent(),
              }) => AiCallsCompanion.insert(
                id: id,
                at: at,
                lane: lane,
                model: model,
                ok: ok,
                cached: cached,
                durationMs: durationMs,
                promptChars: promptChars,
                responseChars: responseChars,
                error: error,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AiCallsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AiCallsTable,
      AiCallRow,
      $$AiCallsTableFilterComposer,
      $$AiCallsTableOrderingComposer,
      $$AiCallsTableAnnotationComposer,
      $$AiCallsTableCreateCompanionBuilder,
      $$AiCallsTableUpdateCompanionBuilder,
      (AiCallRow, BaseReferences<_$AppDatabase, $AiCallsTable, AiCallRow>),
      AiCallRow,
      PrefetchHooks Function()
    >;
typedef $$AiCacheEntriesTableCreateCompanionBuilder =
    AiCacheEntriesCompanion Function({
      required String cacheKey,
      required String lane,
      required String response,
      required DateTime at,
      Value<int> rowid,
    });
typedef $$AiCacheEntriesTableUpdateCompanionBuilder =
    AiCacheEntriesCompanion Function({
      Value<String> cacheKey,
      Value<String> lane,
      Value<String> response,
      Value<DateTime> at,
      Value<int> rowid,
    });

class $$AiCacheEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $AiCacheEntriesTable> {
  $$AiCacheEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get cacheKey => $composableBuilder(
    column: $table.cacheKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lane => $composableBuilder(
    column: $table.lane,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get response => $composableBuilder(
    column: $table.response,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AiCacheEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $AiCacheEntriesTable> {
  $$AiCacheEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get cacheKey => $composableBuilder(
    column: $table.cacheKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lane => $composableBuilder(
    column: $table.lane,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get response => $composableBuilder(
    column: $table.response,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AiCacheEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AiCacheEntriesTable> {
  $$AiCacheEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get cacheKey =>
      $composableBuilder(column: $table.cacheKey, builder: (column) => column);

  GeneratedColumn<String> get lane =>
      $composableBuilder(column: $table.lane, builder: (column) => column);

  GeneratedColumn<String> get response =>
      $composableBuilder(column: $table.response, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);
}

class $$AiCacheEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AiCacheEntriesTable,
          AiCacheRow,
          $$AiCacheEntriesTableFilterComposer,
          $$AiCacheEntriesTableOrderingComposer,
          $$AiCacheEntriesTableAnnotationComposer,
          $$AiCacheEntriesTableCreateCompanionBuilder,
          $$AiCacheEntriesTableUpdateCompanionBuilder,
          (
            AiCacheRow,
            BaseReferences<_$AppDatabase, $AiCacheEntriesTable, AiCacheRow>,
          ),
          AiCacheRow,
          PrefetchHooks Function()
        > {
  $$AiCacheEntriesTableTableManager(
    _$AppDatabase db,
    $AiCacheEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiCacheEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiCacheEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AiCacheEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> cacheKey = const Value.absent(),
                Value<String> lane = const Value.absent(),
                Value<String> response = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiCacheEntriesCompanion(
                cacheKey: cacheKey,
                lane: lane,
                response: response,
                at: at,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String cacheKey,
                required String lane,
                required String response,
                required DateTime at,
                Value<int> rowid = const Value.absent(),
              }) => AiCacheEntriesCompanion.insert(
                cacheKey: cacheKey,
                lane: lane,
                response: response,
                at: at,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AiCacheEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AiCacheEntriesTable,
      AiCacheRow,
      $$AiCacheEntriesTableFilterComposer,
      $$AiCacheEntriesTableOrderingComposer,
      $$AiCacheEntriesTableAnnotationComposer,
      $$AiCacheEntriesTableCreateCompanionBuilder,
      $$AiCacheEntriesTableUpdateCompanionBuilder,
      (
        AiCacheRow,
        BaseReferences<_$AppDatabase, $AiCacheEntriesTable, AiCacheRow>,
      ),
      AiCacheRow,
      PrefetchHooks Function()
    >;
typedef $$BodyMeasurementsTableCreateCompanionBuilder =
    BodyMeasurementsCompanion Function({
      Value<int> day,
      Value<int?> atMinutes,
      required double weightKg,
      Value<double?> heightCm,
      Value<double?> bmi,
      Value<double?> bodyFatPercent,
      Value<double?> fatMassKg,
      Value<double?> fatFreeMassKg,
      Value<double?> muscleMassKg,
      Value<double?> skeletalMuscleKg,
      Value<double?> skeletalMusclePercent,
      Value<double?> boneMassKg,
      Value<double?> proteinKg,
      Value<int?> visceralFat,
      Value<double?> totalBodyWaterKg,
      Value<double?> totalBodyWaterPercent,
      Value<double?> extracellularWaterKg,
      Value<double?> intracellularWaterKg,
      Value<double?> ecwOverTbwPercent,
      Value<int?> bmrKcal,
      Value<int?> bmrKj,
      Value<int?> metabolicAge,
      Value<double?> sarcopenicIndex,
      Value<double?> phaseAngleDeg,
      Value<int?> impedanceOhm,
      Value<String> source,
      Value<String?> note,
    });
typedef $$BodyMeasurementsTableUpdateCompanionBuilder =
    BodyMeasurementsCompanion Function({
      Value<int> day,
      Value<int?> atMinutes,
      Value<double> weightKg,
      Value<double?> heightCm,
      Value<double?> bmi,
      Value<double?> bodyFatPercent,
      Value<double?> fatMassKg,
      Value<double?> fatFreeMassKg,
      Value<double?> muscleMassKg,
      Value<double?> skeletalMuscleKg,
      Value<double?> skeletalMusclePercent,
      Value<double?> boneMassKg,
      Value<double?> proteinKg,
      Value<int?> visceralFat,
      Value<double?> totalBodyWaterKg,
      Value<double?> totalBodyWaterPercent,
      Value<double?> extracellularWaterKg,
      Value<double?> intracellularWaterKg,
      Value<double?> ecwOverTbwPercent,
      Value<int?> bmrKcal,
      Value<int?> bmrKj,
      Value<int?> metabolicAge,
      Value<double?> sarcopenicIndex,
      Value<double?> phaseAngleDeg,
      Value<int?> impedanceOhm,
      Value<String> source,
      Value<String?> note,
    });

class $$BodyMeasurementsTableFilterComposer
    extends Composer<_$AppDatabase, $BodyMeasurementsTable> {
  $$BodyMeasurementsTableFilterComposer({
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

  ColumnFilters<int> get atMinutes => $composableBuilder(
    column: $table.atMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bmi => $composableBuilder(
    column: $table.bmi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bodyFatPercent => $composableBuilder(
    column: $table.bodyFatPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatMassKg => $composableBuilder(
    column: $table.fatMassKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatFreeMassKg => $composableBuilder(
    column: $table.fatFreeMassKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get muscleMassKg => $composableBuilder(
    column: $table.muscleMassKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get skeletalMuscleKg => $composableBuilder(
    column: $table.skeletalMuscleKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get skeletalMusclePercent => $composableBuilder(
    column: $table.skeletalMusclePercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get boneMassKg => $composableBuilder(
    column: $table.boneMassKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinKg => $composableBuilder(
    column: $table.proteinKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get visceralFat => $composableBuilder(
    column: $table.visceralFat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalBodyWaterKg => $composableBuilder(
    column: $table.totalBodyWaterKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalBodyWaterPercent => $composableBuilder(
    column: $table.totalBodyWaterPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get extracellularWaterKg => $composableBuilder(
    column: $table.extracellularWaterKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get intracellularWaterKg => $composableBuilder(
    column: $table.intracellularWaterKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ecwOverTbwPercent => $composableBuilder(
    column: $table.ecwOverTbwPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bmrKcal => $composableBuilder(
    column: $table.bmrKcal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bmrKj => $composableBuilder(
    column: $table.bmrKj,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get metabolicAge => $composableBuilder(
    column: $table.metabolicAge,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sarcopenicIndex => $composableBuilder(
    column: $table.sarcopenicIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get phaseAngleDeg => $composableBuilder(
    column: $table.phaseAngleDeg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get impedanceOhm => $composableBuilder(
    column: $table.impedanceOhm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BodyMeasurementsTableOrderingComposer
    extends Composer<_$AppDatabase, $BodyMeasurementsTable> {
  $$BodyMeasurementsTableOrderingComposer({
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

  ColumnOrderings<int> get atMinutes => $composableBuilder(
    column: $table.atMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bmi => $composableBuilder(
    column: $table.bmi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bodyFatPercent => $composableBuilder(
    column: $table.bodyFatPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatMassKg => $composableBuilder(
    column: $table.fatMassKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatFreeMassKg => $composableBuilder(
    column: $table.fatFreeMassKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get muscleMassKg => $composableBuilder(
    column: $table.muscleMassKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get skeletalMuscleKg => $composableBuilder(
    column: $table.skeletalMuscleKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get skeletalMusclePercent => $composableBuilder(
    column: $table.skeletalMusclePercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get boneMassKg => $composableBuilder(
    column: $table.boneMassKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinKg => $composableBuilder(
    column: $table.proteinKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get visceralFat => $composableBuilder(
    column: $table.visceralFat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalBodyWaterKg => $composableBuilder(
    column: $table.totalBodyWaterKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalBodyWaterPercent => $composableBuilder(
    column: $table.totalBodyWaterPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get extracellularWaterKg => $composableBuilder(
    column: $table.extracellularWaterKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get intracellularWaterKg => $composableBuilder(
    column: $table.intracellularWaterKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ecwOverTbwPercent => $composableBuilder(
    column: $table.ecwOverTbwPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bmrKcal => $composableBuilder(
    column: $table.bmrKcal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bmrKj => $composableBuilder(
    column: $table.bmrKj,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get metabolicAge => $composableBuilder(
    column: $table.metabolicAge,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sarcopenicIndex => $composableBuilder(
    column: $table.sarcopenicIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get phaseAngleDeg => $composableBuilder(
    column: $table.phaseAngleDeg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get impedanceOhm => $composableBuilder(
    column: $table.impedanceOhm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BodyMeasurementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BodyMeasurementsTable> {
  $$BodyMeasurementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<int> get atMinutes =>
      $composableBuilder(column: $table.atMinutes, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<double> get bmi =>
      $composableBuilder(column: $table.bmi, builder: (column) => column);

  GeneratedColumn<double> get bodyFatPercent => $composableBuilder(
    column: $table.bodyFatPercent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fatMassKg =>
      $composableBuilder(column: $table.fatMassKg, builder: (column) => column);

  GeneratedColumn<double> get fatFreeMassKg => $composableBuilder(
    column: $table.fatFreeMassKg,
    builder: (column) => column,
  );

  GeneratedColumn<double> get muscleMassKg => $composableBuilder(
    column: $table.muscleMassKg,
    builder: (column) => column,
  );

  GeneratedColumn<double> get skeletalMuscleKg => $composableBuilder(
    column: $table.skeletalMuscleKg,
    builder: (column) => column,
  );

  GeneratedColumn<double> get skeletalMusclePercent => $composableBuilder(
    column: $table.skeletalMusclePercent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get boneMassKg => $composableBuilder(
    column: $table.boneMassKg,
    builder: (column) => column,
  );

  GeneratedColumn<double> get proteinKg =>
      $composableBuilder(column: $table.proteinKg, builder: (column) => column);

  GeneratedColumn<int> get visceralFat => $composableBuilder(
    column: $table.visceralFat,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalBodyWaterKg => $composableBuilder(
    column: $table.totalBodyWaterKg,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalBodyWaterPercent => $composableBuilder(
    column: $table.totalBodyWaterPercent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get extracellularWaterKg => $composableBuilder(
    column: $table.extracellularWaterKg,
    builder: (column) => column,
  );

  GeneratedColumn<double> get intracellularWaterKg => $composableBuilder(
    column: $table.intracellularWaterKg,
    builder: (column) => column,
  );

  GeneratedColumn<double> get ecwOverTbwPercent => $composableBuilder(
    column: $table.ecwOverTbwPercent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bmrKcal =>
      $composableBuilder(column: $table.bmrKcal, builder: (column) => column);

  GeneratedColumn<int> get bmrKj =>
      $composableBuilder(column: $table.bmrKj, builder: (column) => column);

  GeneratedColumn<int> get metabolicAge => $composableBuilder(
    column: $table.metabolicAge,
    builder: (column) => column,
  );

  GeneratedColumn<double> get sarcopenicIndex => $composableBuilder(
    column: $table.sarcopenicIndex,
    builder: (column) => column,
  );

  GeneratedColumn<double> get phaseAngleDeg => $composableBuilder(
    column: $table.phaseAngleDeg,
    builder: (column) => column,
  );

  GeneratedColumn<int> get impedanceOhm => $composableBuilder(
    column: $table.impedanceOhm,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$BodyMeasurementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BodyMeasurementsTable,
          BodyMeasurementRow,
          $$BodyMeasurementsTableFilterComposer,
          $$BodyMeasurementsTableOrderingComposer,
          $$BodyMeasurementsTableAnnotationComposer,
          $$BodyMeasurementsTableCreateCompanionBuilder,
          $$BodyMeasurementsTableUpdateCompanionBuilder,
          (
            BodyMeasurementRow,
            BaseReferences<
              _$AppDatabase,
              $BodyMeasurementsTable,
              BodyMeasurementRow
            >,
          ),
          BodyMeasurementRow,
          PrefetchHooks Function()
        > {
  $$BodyMeasurementsTableTableManager(
    _$AppDatabase db,
    $BodyMeasurementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BodyMeasurementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BodyMeasurementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BodyMeasurementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> day = const Value.absent(),
                Value<int?> atMinutes = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<double?> heightCm = const Value.absent(),
                Value<double?> bmi = const Value.absent(),
                Value<double?> bodyFatPercent = const Value.absent(),
                Value<double?> fatMassKg = const Value.absent(),
                Value<double?> fatFreeMassKg = const Value.absent(),
                Value<double?> muscleMassKg = const Value.absent(),
                Value<double?> skeletalMuscleKg = const Value.absent(),
                Value<double?> skeletalMusclePercent = const Value.absent(),
                Value<double?> boneMassKg = const Value.absent(),
                Value<double?> proteinKg = const Value.absent(),
                Value<int?> visceralFat = const Value.absent(),
                Value<double?> totalBodyWaterKg = const Value.absent(),
                Value<double?> totalBodyWaterPercent = const Value.absent(),
                Value<double?> extracellularWaterKg = const Value.absent(),
                Value<double?> intracellularWaterKg = const Value.absent(),
                Value<double?> ecwOverTbwPercent = const Value.absent(),
                Value<int?> bmrKcal = const Value.absent(),
                Value<int?> bmrKj = const Value.absent(),
                Value<int?> metabolicAge = const Value.absent(),
                Value<double?> sarcopenicIndex = const Value.absent(),
                Value<double?> phaseAngleDeg = const Value.absent(),
                Value<int?> impedanceOhm = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => BodyMeasurementsCompanion(
                day: day,
                atMinutes: atMinutes,
                weightKg: weightKg,
                heightCm: heightCm,
                bmi: bmi,
                bodyFatPercent: bodyFatPercent,
                fatMassKg: fatMassKg,
                fatFreeMassKg: fatFreeMassKg,
                muscleMassKg: muscleMassKg,
                skeletalMuscleKg: skeletalMuscleKg,
                skeletalMusclePercent: skeletalMusclePercent,
                boneMassKg: boneMassKg,
                proteinKg: proteinKg,
                visceralFat: visceralFat,
                totalBodyWaterKg: totalBodyWaterKg,
                totalBodyWaterPercent: totalBodyWaterPercent,
                extracellularWaterKg: extracellularWaterKg,
                intracellularWaterKg: intracellularWaterKg,
                ecwOverTbwPercent: ecwOverTbwPercent,
                bmrKcal: bmrKcal,
                bmrKj: bmrKj,
                metabolicAge: metabolicAge,
                sarcopenicIndex: sarcopenicIndex,
                phaseAngleDeg: phaseAngleDeg,
                impedanceOhm: impedanceOhm,
                source: source,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> day = const Value.absent(),
                Value<int?> atMinutes = const Value.absent(),
                required double weightKg,
                Value<double?> heightCm = const Value.absent(),
                Value<double?> bmi = const Value.absent(),
                Value<double?> bodyFatPercent = const Value.absent(),
                Value<double?> fatMassKg = const Value.absent(),
                Value<double?> fatFreeMassKg = const Value.absent(),
                Value<double?> muscleMassKg = const Value.absent(),
                Value<double?> skeletalMuscleKg = const Value.absent(),
                Value<double?> skeletalMusclePercent = const Value.absent(),
                Value<double?> boneMassKg = const Value.absent(),
                Value<double?> proteinKg = const Value.absent(),
                Value<int?> visceralFat = const Value.absent(),
                Value<double?> totalBodyWaterKg = const Value.absent(),
                Value<double?> totalBodyWaterPercent = const Value.absent(),
                Value<double?> extracellularWaterKg = const Value.absent(),
                Value<double?> intracellularWaterKg = const Value.absent(),
                Value<double?> ecwOverTbwPercent = const Value.absent(),
                Value<int?> bmrKcal = const Value.absent(),
                Value<int?> bmrKj = const Value.absent(),
                Value<int?> metabolicAge = const Value.absent(),
                Value<double?> sarcopenicIndex = const Value.absent(),
                Value<double?> phaseAngleDeg = const Value.absent(),
                Value<int?> impedanceOhm = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => BodyMeasurementsCompanion.insert(
                day: day,
                atMinutes: atMinutes,
                weightKg: weightKg,
                heightCm: heightCm,
                bmi: bmi,
                bodyFatPercent: bodyFatPercent,
                fatMassKg: fatMassKg,
                fatFreeMassKg: fatFreeMassKg,
                muscleMassKg: muscleMassKg,
                skeletalMuscleKg: skeletalMuscleKg,
                skeletalMusclePercent: skeletalMusclePercent,
                boneMassKg: boneMassKg,
                proteinKg: proteinKg,
                visceralFat: visceralFat,
                totalBodyWaterKg: totalBodyWaterKg,
                totalBodyWaterPercent: totalBodyWaterPercent,
                extracellularWaterKg: extracellularWaterKg,
                intracellularWaterKg: intracellularWaterKg,
                ecwOverTbwPercent: ecwOverTbwPercent,
                bmrKcal: bmrKcal,
                bmrKj: bmrKj,
                metabolicAge: metabolicAge,
                sarcopenicIndex: sarcopenicIndex,
                phaseAngleDeg: phaseAngleDeg,
                impedanceOhm: impedanceOhm,
                source: source,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BodyMeasurementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BodyMeasurementsTable,
      BodyMeasurementRow,
      $$BodyMeasurementsTableFilterComposer,
      $$BodyMeasurementsTableOrderingComposer,
      $$BodyMeasurementsTableAnnotationComposer,
      $$BodyMeasurementsTableCreateCompanionBuilder,
      $$BodyMeasurementsTableUpdateCompanionBuilder,
      (
        BodyMeasurementRow,
        BaseReferences<
          _$AppDatabase,
          $BodyMeasurementsTable,
          BodyMeasurementRow
        >,
      ),
      BodyMeasurementRow,
      PrefetchHooks Function()
    >;
typedef $$BodySegmentsTableCreateCompanionBuilder =
    BodySegmentsCompanion Function({
      required int day,
      required BodySegment segment,
      Value<double?> fatPercent,
      Value<double?> fatKg,
      Value<double?> muscleKg,
      Value<double?> fatFreeMassKg,
      Value<double?> otherMassKg,
      Value<int?> fatRating,
      Value<int?> muscleRating,
      Value<int> rowid,
    });
typedef $$BodySegmentsTableUpdateCompanionBuilder =
    BodySegmentsCompanion Function({
      Value<int> day,
      Value<BodySegment> segment,
      Value<double?> fatPercent,
      Value<double?> fatKg,
      Value<double?> muscleKg,
      Value<double?> fatFreeMassKg,
      Value<double?> otherMassKg,
      Value<int?> fatRating,
      Value<int?> muscleRating,
      Value<int> rowid,
    });

class $$BodySegmentsTableFilterComposer
    extends Composer<_$AppDatabase, $BodySegmentsTable> {
  $$BodySegmentsTableFilterComposer({
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

  ColumnWithTypeConverterFilters<BodySegment, BodySegment, String>
  get segment => $composableBuilder(
    column: $table.segment,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get fatPercent => $composableBuilder(
    column: $table.fatPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatKg => $composableBuilder(
    column: $table.fatKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get muscleKg => $composableBuilder(
    column: $table.muscleKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatFreeMassKg => $composableBuilder(
    column: $table.fatFreeMassKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get otherMassKg => $composableBuilder(
    column: $table.otherMassKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fatRating => $composableBuilder(
    column: $table.fatRating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get muscleRating => $composableBuilder(
    column: $table.muscleRating,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BodySegmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $BodySegmentsTable> {
  $$BodySegmentsTableOrderingComposer({
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

  ColumnOrderings<String> get segment => $composableBuilder(
    column: $table.segment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatPercent => $composableBuilder(
    column: $table.fatPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatKg => $composableBuilder(
    column: $table.fatKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get muscleKg => $composableBuilder(
    column: $table.muscleKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatFreeMassKg => $composableBuilder(
    column: $table.fatFreeMassKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get otherMassKg => $composableBuilder(
    column: $table.otherMassKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fatRating => $composableBuilder(
    column: $table.fatRating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get muscleRating => $composableBuilder(
    column: $table.muscleRating,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BodySegmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BodySegmentsTable> {
  $$BodySegmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumnWithTypeConverter<BodySegment, String> get segment =>
      $composableBuilder(column: $table.segment, builder: (column) => column);

  GeneratedColumn<double> get fatPercent => $composableBuilder(
    column: $table.fatPercent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fatKg =>
      $composableBuilder(column: $table.fatKg, builder: (column) => column);

  GeneratedColumn<double> get muscleKg =>
      $composableBuilder(column: $table.muscleKg, builder: (column) => column);

  GeneratedColumn<double> get fatFreeMassKg => $composableBuilder(
    column: $table.fatFreeMassKg,
    builder: (column) => column,
  );

  GeneratedColumn<double> get otherMassKg => $composableBuilder(
    column: $table.otherMassKg,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fatRating =>
      $composableBuilder(column: $table.fatRating, builder: (column) => column);

  GeneratedColumn<int> get muscleRating => $composableBuilder(
    column: $table.muscleRating,
    builder: (column) => column,
  );
}

class $$BodySegmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BodySegmentsTable,
          BodySegmentRow,
          $$BodySegmentsTableFilterComposer,
          $$BodySegmentsTableOrderingComposer,
          $$BodySegmentsTableAnnotationComposer,
          $$BodySegmentsTableCreateCompanionBuilder,
          $$BodySegmentsTableUpdateCompanionBuilder,
          (
            BodySegmentRow,
            BaseReferences<_$AppDatabase, $BodySegmentsTable, BodySegmentRow>,
          ),
          BodySegmentRow,
          PrefetchHooks Function()
        > {
  $$BodySegmentsTableTableManager(_$AppDatabase db, $BodySegmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BodySegmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BodySegmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BodySegmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> day = const Value.absent(),
                Value<BodySegment> segment = const Value.absent(),
                Value<double?> fatPercent = const Value.absent(),
                Value<double?> fatKg = const Value.absent(),
                Value<double?> muscleKg = const Value.absent(),
                Value<double?> fatFreeMassKg = const Value.absent(),
                Value<double?> otherMassKg = const Value.absent(),
                Value<int?> fatRating = const Value.absent(),
                Value<int?> muscleRating = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BodySegmentsCompanion(
                day: day,
                segment: segment,
                fatPercent: fatPercent,
                fatKg: fatKg,
                muscleKg: muscleKg,
                fatFreeMassKg: fatFreeMassKg,
                otherMassKg: otherMassKg,
                fatRating: fatRating,
                muscleRating: muscleRating,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int day,
                required BodySegment segment,
                Value<double?> fatPercent = const Value.absent(),
                Value<double?> fatKg = const Value.absent(),
                Value<double?> muscleKg = const Value.absent(),
                Value<double?> fatFreeMassKg = const Value.absent(),
                Value<double?> otherMassKg = const Value.absent(),
                Value<int?> fatRating = const Value.absent(),
                Value<int?> muscleRating = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BodySegmentsCompanion.insert(
                day: day,
                segment: segment,
                fatPercent: fatPercent,
                fatKg: fatKg,
                muscleKg: muscleKg,
                fatFreeMassKg: fatFreeMassKg,
                otherMassKg: otherMassKg,
                fatRating: fatRating,
                muscleRating: muscleRating,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BodySegmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BodySegmentsTable,
      BodySegmentRow,
      $$BodySegmentsTableFilterComposer,
      $$BodySegmentsTableOrderingComposer,
      $$BodySegmentsTableAnnotationComposer,
      $$BodySegmentsTableCreateCompanionBuilder,
      $$BodySegmentsTableUpdateCompanionBuilder,
      (
        BodySegmentRow,
        BaseReferences<_$AppDatabase, $BodySegmentsTable, BodySegmentRow>,
      ),
      BodySegmentRow,
      PrefetchHooks Function()
    >;
typedef $$LabResultsTableCreateCompanionBuilder = LabResultsCompanion Function({
  required int day,
  required String panel,
  required String name,
  Value<double?> value,
  Value<String?> textValue,
  Value<String> unit,
  Value<double?> refLow,
  Value<double?> refHigh,
  Value<String> refText,
  Value<String> flag,
  Value<String> source,
  Value<int> rowid,
});
typedef $$LabResultsTableUpdateCompanionBuilder = LabResultsCompanion Function({
  Value<int> day,
  Value<String> panel,
  Value<String> name,
  Value<double?> value,
  Value<String?> textValue,
  Value<String> unit,
  Value<double?> refLow,
  Value<double?> refHigh,
  Value<String> refText,
  Value<String> flag,
  Value<String> source,
  Value<int> rowid,
});

class $$LabResultsTableFilterComposer
    extends Composer<_$AppDatabase, $LabResultsTable> {
  $$LabResultsTableFilterComposer({
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

  ColumnFilters<String> get panel => $composableBuilder(
    column: $table.panel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textValue => $composableBuilder(
    column: $table.textValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get refLow => $composableBuilder(
    column: $table.refLow,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get refHigh => $composableBuilder(
    column: $table.refHigh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get refText => $composableBuilder(
    column: $table.refText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get flag => $composableBuilder(
    column: $table.flag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LabResultsTableOrderingComposer
    extends Composer<_$AppDatabase, $LabResultsTable> {
  $$LabResultsTableOrderingComposer({
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

  ColumnOrderings<String> get panel => $composableBuilder(
    column: $table.panel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textValue => $composableBuilder(
    column: $table.textValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get refLow => $composableBuilder(
    column: $table.refLow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get refHigh => $composableBuilder(
    column: $table.refHigh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refText => $composableBuilder(
    column: $table.refText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get flag => $composableBuilder(
    column: $table.flag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LabResultsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LabResultsTable> {
  $$LabResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<String> get panel =>
      $composableBuilder(column: $table.panel, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get textValue =>
      $composableBuilder(column: $table.textValue, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get refLow =>
      $composableBuilder(column: $table.refLow, builder: (column) => column);

  GeneratedColumn<double> get refHigh =>
      $composableBuilder(column: $table.refHigh, builder: (column) => column);

  GeneratedColumn<String> get refText =>
      $composableBuilder(column: $table.refText, builder: (column) => column);

  GeneratedColumn<String> get flag =>
      $composableBuilder(column: $table.flag, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);
}

class $$LabResultsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LabResultsTable,
          LabResultRow,
          $$LabResultsTableFilterComposer,
          $$LabResultsTableOrderingComposer,
          $$LabResultsTableAnnotationComposer,
          $$LabResultsTableCreateCompanionBuilder,
          $$LabResultsTableUpdateCompanionBuilder,
          (
            LabResultRow,
            BaseReferences<_$AppDatabase, $LabResultsTable, LabResultRow>,
          ),
          LabResultRow,
          PrefetchHooks Function()
        > {
  $$LabResultsTableTableManager(_$AppDatabase db, $LabResultsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LabResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LabResultsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LabResultsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> day = const Value.absent(),
                Value<String> panel = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double?> value = const Value.absent(),
                Value<String?> textValue = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<double?> refLow = const Value.absent(),
                Value<double?> refHigh = const Value.absent(),
                Value<String> refText = const Value.absent(),
                Value<String> flag = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LabResultsCompanion(
                day: day,
                panel: panel,
                name: name,
                value: value,
                textValue: textValue,
                unit: unit,
                refLow: refLow,
                refHigh: refHigh,
                refText: refText,
                flag: flag,
                source: source,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int day,
                required String panel,
                required String name,
                Value<double?> value = const Value.absent(),
                Value<String?> textValue = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<double?> refLow = const Value.absent(),
                Value<double?> refHigh = const Value.absent(),
                Value<String> refText = const Value.absent(),
                Value<String> flag = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LabResultsCompanion.insert(
                day: day,
                panel: panel,
                name: name,
                value: value,
                textValue: textValue,
                unit: unit,
                refLow: refLow,
                refHigh: refHigh,
                refText: refText,
                flag: flag,
                source: source,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LabResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LabResultsTable,
      LabResultRow,
      $$LabResultsTableFilterComposer,
      $$LabResultsTableOrderingComposer,
      $$LabResultsTableAnnotationComposer,
      $$LabResultsTableCreateCompanionBuilder,
      $$LabResultsTableUpdateCompanionBuilder,
      (
        LabResultRow,
        BaseReferences<_$AppDatabase, $LabResultsTable, LabResultRow>,
      ),
      LabResultRow,
      PrefetchHooks Function()
    >;
typedef $$HealthDaysTableCreateCompanionBuilder = HealthDaysCompanion Function({
  Value<int> day,
  Value<int?> steps,
  Value<int?> sleepMinutes,
  Value<int?> restingHeartRate,
  Value<int?> activeKcal,
  Value<int?> distanceM,
  Value<int?> workoutMinutes,
  required DateTime syncedAt,
});
typedef $$HealthDaysTableUpdateCompanionBuilder = HealthDaysCompanion Function({
  Value<int> day,
  Value<int?> steps,
  Value<int?> sleepMinutes,
  Value<int?> restingHeartRate,
  Value<int?> activeKcal,
  Value<int?> distanceM,
  Value<int?> workoutMinutes,
  Value<DateTime> syncedAt,
});

class $$HealthDaysTableFilterComposer
    extends Composer<_$AppDatabase, $HealthDaysTable> {
  $$HealthDaysTableFilterComposer({
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

  ColumnFilters<int> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sleepMinutes => $composableBuilder(
    column: $table.sleepMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restingHeartRate => $composableBuilder(
    column: $table.restingHeartRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get activeKcal => $composableBuilder(
    column: $table.activeKcal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get distanceM => $composableBuilder(
    column: $table.distanceM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get workoutMinutes => $composableBuilder(
    column: $table.workoutMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HealthDaysTableOrderingComposer
    extends Composer<_$AppDatabase, $HealthDaysTable> {
  $$HealthDaysTableOrderingComposer({
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

  ColumnOrderings<int> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sleepMinutes => $composableBuilder(
    column: $table.sleepMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restingHeartRate => $composableBuilder(
    column: $table.restingHeartRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get activeKcal => $composableBuilder(
    column: $table.activeKcal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get distanceM => $composableBuilder(
    column: $table.distanceM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get workoutMinutes => $composableBuilder(
    column: $table.workoutMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HealthDaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $HealthDaysTable> {
  $$HealthDaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<int> get steps =>
      $composableBuilder(column: $table.steps, builder: (column) => column);

  GeneratedColumn<int> get sleepMinutes => $composableBuilder(
    column: $table.sleepMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get restingHeartRate => $composableBuilder(
    column: $table.restingHeartRate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get activeKcal => $composableBuilder(
    column: $table.activeKcal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get distanceM =>
      $composableBuilder(column: $table.distanceM, builder: (column) => column);

  GeneratedColumn<int> get workoutMinutes => $composableBuilder(
    column: $table.workoutMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$HealthDaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HealthDaysTable,
          HealthDayRow,
          $$HealthDaysTableFilterComposer,
          $$HealthDaysTableOrderingComposer,
          $$HealthDaysTableAnnotationComposer,
          $$HealthDaysTableCreateCompanionBuilder,
          $$HealthDaysTableUpdateCompanionBuilder,
          (
            HealthDayRow,
            BaseReferences<_$AppDatabase, $HealthDaysTable, HealthDayRow>,
          ),
          HealthDayRow,
          PrefetchHooks Function()
        > {
  $$HealthDaysTableTableManager(_$AppDatabase db, $HealthDaysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HealthDaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HealthDaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HealthDaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> day = const Value.absent(),
                Value<int?> steps = const Value.absent(),
                Value<int?> sleepMinutes = const Value.absent(),
                Value<int?> restingHeartRate = const Value.absent(),
                Value<int?> activeKcal = const Value.absent(),
                Value<int?> distanceM = const Value.absent(),
                Value<int?> workoutMinutes = const Value.absent(),
                Value<DateTime> syncedAt = const Value.absent(),
              }) => HealthDaysCompanion(
                day: day,
                steps: steps,
                sleepMinutes: sleepMinutes,
                restingHeartRate: restingHeartRate,
                activeKcal: activeKcal,
                distanceM: distanceM,
                workoutMinutes: workoutMinutes,
                syncedAt: syncedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> day = const Value.absent(),
                Value<int?> steps = const Value.absent(),
                Value<int?> sleepMinutes = const Value.absent(),
                Value<int?> restingHeartRate = const Value.absent(),
                Value<int?> activeKcal = const Value.absent(),
                Value<int?> distanceM = const Value.absent(),
                Value<int?> workoutMinutes = const Value.absent(),
                required DateTime syncedAt,
              }) => HealthDaysCompanion.insert(
                day: day,
                steps: steps,
                sleepMinutes: sleepMinutes,
                restingHeartRate: restingHeartRate,
                activeKcal: activeKcal,
                distanceM: distanceM,
                workoutMinutes: workoutMinutes,
                syncedAt: syncedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HealthDaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HealthDaysTable,
      HealthDayRow,
      $$HealthDaysTableFilterComposer,
      $$HealthDaysTableOrderingComposer,
      $$HealthDaysTableAnnotationComposer,
      $$HealthDaysTableCreateCompanionBuilder,
      $$HealthDaysTableUpdateCompanionBuilder,
      (
        HealthDayRow,
        BaseReferences<_$AppDatabase, $HealthDaysTable, HealthDayRow>,
      ),
      HealthDayRow,
      PrefetchHooks Function()
    >;
typedef $$WeeklyReviewsTableCreateCompanionBuilder =
    WeeklyReviewsCompanion Function({
      Value<int> weekEndDay,
      required String summary,
      required String kept,
      required String change,
      Value<String> source,
      required DateTime generatedAt,
    });
typedef $$WeeklyReviewsTableUpdateCompanionBuilder =
    WeeklyReviewsCompanion Function({
      Value<int> weekEndDay,
      Value<String> summary,
      Value<String> kept,
      Value<String> change,
      Value<String> source,
      Value<DateTime> generatedAt,
    });

class $$WeeklyReviewsTableFilterComposer
    extends Composer<_$AppDatabase, $WeeklyReviewsTable> {
  $$WeeklyReviewsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get weekEndDay => $composableBuilder(
    column: $table.weekEndDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kept => $composableBuilder(
    column: $table.kept,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get change => $composableBuilder(
    column: $table.change,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeeklyReviewsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeeklyReviewsTable> {
  $$WeeklyReviewsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get weekEndDay => $composableBuilder(
    column: $table.weekEndDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kept => $composableBuilder(
    column: $table.kept,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get change => $composableBuilder(
    column: $table.change,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeeklyReviewsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeeklyReviewsTable> {
  $$WeeklyReviewsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get weekEndDay => $composableBuilder(
    column: $table.weekEndDay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get kept =>
      $composableBuilder(column: $table.kept, builder: (column) => column);

  GeneratedColumn<String> get change =>
      $composableBuilder(column: $table.change, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => column,
  );
}

class $$WeeklyReviewsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeeklyReviewsTable,
          WeeklyReviewRow,
          $$WeeklyReviewsTableFilterComposer,
          $$WeeklyReviewsTableOrderingComposer,
          $$WeeklyReviewsTableAnnotationComposer,
          $$WeeklyReviewsTableCreateCompanionBuilder,
          $$WeeklyReviewsTableUpdateCompanionBuilder,
          (
            WeeklyReviewRow,
            BaseReferences<_$AppDatabase, $WeeklyReviewsTable, WeeklyReviewRow>,
          ),
          WeeklyReviewRow,
          PrefetchHooks Function()
        > {
  $$WeeklyReviewsTableTableManager(_$AppDatabase db, $WeeklyReviewsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeeklyReviewsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeeklyReviewsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeeklyReviewsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> weekEndDay = const Value.absent(),
                Value<String> summary = const Value.absent(),
                Value<String> kept = const Value.absent(),
                Value<String> change = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<DateTime> generatedAt = const Value.absent(),
              }) => WeeklyReviewsCompanion(
                weekEndDay: weekEndDay,
                summary: summary,
                kept: kept,
                change: change,
                source: source,
                generatedAt: generatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> weekEndDay = const Value.absent(),
                required String summary,
                required String kept,
                required String change,
                Value<String> source = const Value.absent(),
                required DateTime generatedAt,
              }) => WeeklyReviewsCompanion.insert(
                weekEndDay: weekEndDay,
                summary: summary,
                kept: kept,
                change: change,
                source: source,
                generatedAt: generatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeeklyReviewsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeeklyReviewsTable,
      WeeklyReviewRow,
      $$WeeklyReviewsTableFilterComposer,
      $$WeeklyReviewsTableOrderingComposer,
      $$WeeklyReviewsTableAnnotationComposer,
      $$WeeklyReviewsTableCreateCompanionBuilder,
      $$WeeklyReviewsTableUpdateCompanionBuilder,
      (
        WeeklyReviewRow,
        BaseReferences<_$AppDatabase, $WeeklyReviewsTable, WeeklyReviewRow>,
      ),
      WeeklyReviewRow,
      PrefetchHooks Function()
    >;
typedef $$DeloadsTableCreateCompanionBuilder = DeloadsCompanion Function({
  Value<int> startDay,
  required String reason,
  required DateTime decidedAt,
});
typedef $$DeloadsTableUpdateCompanionBuilder = DeloadsCompanion Function({
  Value<int> startDay,
  Value<String> reason,
  Value<DateTime> decidedAt,
});

class $$DeloadsTableFilterComposer
    extends Composer<_$AppDatabase, $DeloadsTable> {
  $$DeloadsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get startDay => $composableBuilder(
    column: $table.startDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get decidedAt => $composableBuilder(
    column: $table.decidedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DeloadsTableOrderingComposer
    extends Composer<_$AppDatabase, $DeloadsTable> {
  $$DeloadsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get startDay => $composableBuilder(
    column: $table.startDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get decidedAt => $composableBuilder(
    column: $table.decidedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DeloadsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeloadsTable> {
  $$DeloadsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get startDay =>
      $composableBuilder(column: $table.startDay, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<DateTime> get decidedAt =>
      $composableBuilder(column: $table.decidedAt, builder: (column) => column);
}

class $$DeloadsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeloadsTable,
          DeloadRow,
          $$DeloadsTableFilterComposer,
          $$DeloadsTableOrderingComposer,
          $$DeloadsTableAnnotationComposer,
          $$DeloadsTableCreateCompanionBuilder,
          $$DeloadsTableUpdateCompanionBuilder,
          (DeloadRow, BaseReferences<_$AppDatabase, $DeloadsTable, DeloadRow>),
          DeloadRow,
          PrefetchHooks Function()
        > {
  $$DeloadsTableTableManager(_$AppDatabase db, $DeloadsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeloadsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeloadsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeloadsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> startDay = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<DateTime> decidedAt = const Value.absent(),
              }) => DeloadsCompanion(
                startDay: startDay,
                reason: reason,
                decidedAt: decidedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> startDay = const Value.absent(),
                required String reason,
                required DateTime decidedAt,
              }) => DeloadsCompanion.insert(
                startDay: startDay,
                reason: reason,
                decidedAt: decidedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DeloadsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeloadsTable,
      DeloadRow,
      $$DeloadsTableFilterComposer,
      $$DeloadsTableOrderingComposer,
      $$DeloadsTableAnnotationComposer,
      $$DeloadsTableCreateCompanionBuilder,
      $$DeloadsTableUpdateCompanionBuilder,
      (DeloadRow, BaseReferences<_$AppDatabase, $DeloadsTable, DeloadRow>),
      DeloadRow,
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
  $$WorkoutSessionsTableTableManager get workoutSessions =>
      $$WorkoutSessionsTableTableManager(_db, _db.workoutSessions);
  $$WorkoutSetsTableTableManager get workoutSets =>
      $$WorkoutSetsTableTableManager(_db, _db.workoutSets);
  $$MemoryDocumentsTableTableManager get memoryDocuments =>
      $$MemoryDocumentsTableTableManager(_db, _db.memoryDocuments);
  $$MemoryChunksTableTableManager get memoryChunks =>
      $$MemoryChunksTableTableManager(_db, _db.memoryChunks);
  $$MealsTableTableManager get meals =>
      $$MealsTableTableManager(_db, _db.meals);
  $$FoodLogEntriesTableTableManager get foodLogEntries =>
      $$FoodLogEntriesTableTableManager(_db, _db.foodLogEntries);
  $$AiCallsTableTableManager get aiCalls =>
      $$AiCallsTableTableManager(_db, _db.aiCalls);
  $$AiCacheEntriesTableTableManager get aiCacheEntries =>
      $$AiCacheEntriesTableTableManager(_db, _db.aiCacheEntries);
  $$BodyMeasurementsTableTableManager get bodyMeasurements =>
      $$BodyMeasurementsTableTableManager(_db, _db.bodyMeasurements);
  $$BodySegmentsTableTableManager get bodySegments =>
      $$BodySegmentsTableTableManager(_db, _db.bodySegments);
  $$LabResultsTableTableManager get labResults =>
      $$LabResultsTableTableManager(_db, _db.labResults);
  $$HealthDaysTableTableManager get healthDays =>
      $$HealthDaysTableTableManager(_db, _db.healthDays);
  $$WeeklyReviewsTableTableManager get weeklyReviews =>
      $$WeeklyReviewsTableTableManager(_db, _db.weeklyReviews);
  $$DeloadsTableTableManager get deloads =>
      $$DeloadsTableTableManager(_db, _db.deloads);
}
