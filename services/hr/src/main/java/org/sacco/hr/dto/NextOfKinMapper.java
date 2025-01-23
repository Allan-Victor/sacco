package org.sacco.hr.dto;

import org.sacco.hr.model.NextOfKin;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import java.sql.ResultSet;
import java.sql.SQLException;

@Component
public class NextOfKinMapper implements RowMapper<NextOfKin> {
    @Override
    public NextOfKin mapRow(ResultSet rs, int rowNum) throws SQLException {
           return new NextOfKin(
                   rs.getInt("nextOfKinId"),
                   rs.getString("fullName"),
                   rs.getInt("staffId"),
                   rs.getString("relationship"),
                   rs.getString("phoneNumber"),
                   rs.getString("kinNin"),
                   rs.getString("physicalAddress")
           );

    }
}

