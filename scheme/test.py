def catch(msg):
    try:
        raise ValueError(msg)
    except ValueError as e:
        return e