define ->
  _groups = {}
  _errors = {}

  register: (input, fn, groupName='default') ->
    group = (_groups[groupName] or= [])
    group.push({input, fn})

  validate: (groupName='default') ->
    group = _groups[groupName]
    console.log 'validating group:', group
    errors = []
    for check in group
      {input, fn} = check
      error = fn(input)
      if error
        errors.push({input, error})

    _errors[groupName] = errors
    return errors.length is 0

  errors: (groupName='default') ->
    return _errors[groupName]