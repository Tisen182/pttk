package dao;

import java.sql.Connection;
import java.util.Objects;

public abstract class DAO {
    protected final Connection con;

    protected DAO(Connection con) {
        this.con = Objects.requireNonNull(con, "A JDBC connection is required.");
    }
}
