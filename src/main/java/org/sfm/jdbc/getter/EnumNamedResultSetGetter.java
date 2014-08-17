package org.sfm.jdbc.getter;

import java.sql.ResultSet;

import org.sfm.reflect.Getter;

public class EnumNamedResultSetGetter<E extends Enum<E>> implements  Getter<ResultSet, E> {

	private final String column;
	private final Class<E> enumType;
	private final E[] values;
	@SuppressWarnings("unchecked")
	public EnumNamedResultSetGetter(String column, Class<E> enumType) {
		this.column = column;
		this.enumType = enumType;
		try {
			this.values = (E[]) enumType.getDeclaredMethod("values").invoke(enumType);
		} catch (Exception e) {
			throw new Error("Unexpected error getting enum values " + e, e);
		}
	}

	@Override
	public E get(ResultSet target) throws Exception {
		Object o = target.getObject(column);
		if (o instanceof Number) {
			return values[((Number) o).intValue()];
		} else {
			return (E) Enum.valueOf(enumType, String.valueOf(o));
		}
	}
}
