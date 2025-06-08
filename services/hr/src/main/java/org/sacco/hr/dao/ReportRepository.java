package org.sacco.hr.dao;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class ReportRepository {
    private final JdbcTemplate jdbcTemplate;

    public ReportRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

public List<Map<String, Object>> getHistoricalReportByStaff(String staffNumber) {
    String sql = "SELECT d.staff_name, d.staff_number, emp.designation, emp.department, " +
             "d.offence_description, d.board_decision " +
             "FROM disciplinary_cases d " +
             "JOIN employees emp ON d.staff_number = emp.staff_number " +
             "WHERE d.staff_number = ?";
    return jdbcTemplate.queryForList(sql, staffNumber);
    }
}