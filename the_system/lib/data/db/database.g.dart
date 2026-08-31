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
  final DateTime? startedAt;
  final DateTime? completedAt;
  const WorkoutSessionRow({
    required this.id,
    required this.day,
    required this.phase,
    required this.week,
    required this.focus,
    this.notes,
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
    Value<DateTime?> startedAt = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
  }) => WorkoutSessionRow(
    id: id ?? this.id,
    day: day ?? this.day,
    phase: phase ?? this.phase,
    week: week ?? this.week,
    focus: focus ?? this.focus,
    notes: notes.present ? notes.value : this.notes,
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
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, day, phase, week, focus, notes, startedAt, completedAt);
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
  final Value<DateTime?> startedAt;
  final Value<DateTime?> completedAt;
  const WorkoutSessionsCompanion({
    this.id = const Value.absent(),
    this.day = const Value.absent(),
    this.phase = const Value.absent(),
    this.week = const Value.absent(),
    this.focus = const Value.absent(),
    this.notes = const Value.absent(),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    exerciseId,
    orderIndex,
    setIndex,
    target,
    actual,
    done,
    completedAt,
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
      done: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}done'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
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
  final bool done;
  final DateTime? completedAt;
  const WorkoutSetRow({
    required this.id,
    required this.sessionId,
    required this.exerciseId,
    required this.orderIndex,
    required this.setIndex,
    required this.target,
    this.actual,
    required this.done,
    this.completedAt,
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
    map['done'] = Variable<bool>(done);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
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
      done: Value(done),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
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
      done: serializer.fromJson<bool>(json['done']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
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
      'done': serializer.toJson<bool>(done),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
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
    bool? done,
    Value<DateTime?> completedAt = const Value.absent(),
  }) => WorkoutSetRow(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    exerciseId: exerciseId ?? this.exerciseId,
    orderIndex: orderIndex ?? this.orderIndex,
    setIndex: setIndex ?? this.setIndex,
    target: target ?? this.target,
    actual: actual.present ? actual.value : this.actual,
    done: done ?? this.done,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
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
      done: data.done.present ? data.done.value : this.done,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
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
          ..write('done: $done, ')
          ..write('completedAt: $completedAt')
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
    done,
    completedAt,
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
          other.done == this.done &&
          other.completedAt == this.completedAt);
}

class WorkoutSetsCompanion extends UpdateCompanion<WorkoutSetRow> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<String> exerciseId;
  final Value<int> orderIndex;
  final Value<int> setIndex;
  final Value<int> target;
  final Value<int?> actual;
  final Value<bool> done;
  final Value<DateTime?> completedAt;
  const WorkoutSetsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.setIndex = const Value.absent(),
    this.target = const Value.absent(),
    this.actual = const Value.absent(),
    this.done = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  WorkoutSetsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required String exerciseId,
    required int orderIndex,
    required int setIndex,
    required int target,
    this.actual = const Value.absent(),
    this.done = const Value.absent(),
    this.completedAt = const Value.absent(),
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
    Expression<bool>? done,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (orderIndex != null) 'order_index': orderIndex,
      if (setIndex != null) 'set_index': setIndex,
      if (target != null) 'target': target,
      if (actual != null) 'actual': actual,
      if (done != null) 'done': done,
      if (completedAt != null) 'completed_at': completedAt,
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
    Value<bool>? done,
    Value<DateTime?>? completedAt,
  }) {
    return WorkoutSetsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      exerciseId: exerciseId ?? this.exerciseId,
      orderIndex: orderIndex ?? this.orderIndex,
      setIndex: setIndex ?? this.setIndex,
      target: target ?? this.target,
      actual: actual ?? this.actual,
      done: done ?? this.done,
      completedAt: completedAt ?? this.completedAt,
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
    if (done.present) {
      map['done'] = Variable<bool>(done.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
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
          ..write('done: $done, ')
          ..write('completedAt: $completedAt')
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
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
              }) => WorkoutSessionsCompanion(
                id: id,
                day: day,
                phase: phase,
                week: week,
                focus: focus,
                notes: notes,
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
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
              }) => WorkoutSessionsCompanion.insert(
                id: id,
                day: day,
                phase: phase,
                week: week,
                focus: focus,
                notes: notes,
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
      Value<bool> done,
      Value<DateTime?> completedAt,
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
      Value<bool> done,
      Value<DateTime?> completedAt,
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

  ColumnFilters<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
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

  ColumnOrderings<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
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

  GeneratedColumn<bool> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

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
                Value<bool> done = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
              }) => WorkoutSetsCompanion(
                id: id,
                sessionId: sessionId,
                exerciseId: exerciseId,
                orderIndex: orderIndex,
                setIndex: setIndex,
                target: target,
                actual: actual,
                done: done,
                completedAt: completedAt,
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
                Value<bool> done = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
              }) => WorkoutSetsCompanion.insert(
                id: id,
                sessionId: sessionId,
                exerciseId: exerciseId,
                orderIndex: orderIndex,
                setIndex: setIndex,
                target: target,
                actual: actual,
                done: done,
                completedAt: completedAt,
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
}
