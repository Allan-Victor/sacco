package org.sacco.hr.dao;

import org.sacco.hr.dto.StaffDepartmentOrderDTO;
import org.sacco.hr.dto.StaffNextOfKinDTO;
import org.sacco.hr.dto.StaffResponseDTO;
import org.sacco.hr.dto.NextOfKinMapper;
import org.sacco.hr.mapper.StaffDTOMapper;
import org.sacco.hr.model.Staff;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository("jdbc")
public class StaffRepository implements StaffDao{
    private final JdbcTemplate jdbcTemplate;
    private final NextOfKinMapper mapper;

    @Autowired
    public StaffRepository(JdbcTemplate jdbcTemplate, NextOfKinMapper mapper) {
        this.jdbcTemplate = jdbcTemplate;
        this.mapper = mapper;
    }

    @Override
    public List<StaffDepartmentOrderDTO> retrieveStaffByDepartmentOrder() {
        var sql = """
                SELECT * FROM staff
                LEFT JOIN department
                ON staff.department_id = department.department_id
                LEFT JOIN job_title
                ON staff.job_title_id = job_title.job_title_id
                LEFT JOIN job_grade
                ON staff.job_grade_id = job_grade.job_grade_id
                ORDER BY department.department_name
                """;
        var rowMapper = BeanPropertyRowMapper.newInstance(Staff.class);
        List<Staff> staffList = jdbcTemplate.query(sql, rowMapper);

        return staffList.stream()
                .map(StaffDTOMapper::fromStaff)
                .toList();
    }

    @Override
    public List<StaffResponseDTO> retrieveStaffDepartmentList(Integer departmentId) {
        var sql = """
                SELECT *, COUNT(staff_id) AS numberOfEmployees
                FROM staff
                LEFT JOIN department
                ON staff.department_id = department.department_id
                LEFT JOIN job_title
                ON staff.job_title_id = job_title.job_title_id
                LEFT JOIN job_grade
                ON staff.job_grade_id = job_grade.job_grade_id
                WHERE department.department_id = ?
                GROUP BY department.department_name
                """;
        var rowMapper = BeanPropertyRowMapper.newInstance(Staff.class);
        List<Staff> staffList = jdbcTemplate.query(sql, rowMapper, departmentId);

        return staffList.stream()
                .map(StaffDTOMapper::toStaffDepartmentResponse)
                .toList();
    }

    @Override
    public List<StaffResponseDTO> retrieveStaffPositionList(Integer jobTitleId) {
        var sql = """
                SELECT *, COUNT(staff_id) AS numberOfEmployees
                FROM staff
                LEFT JOIN job_title
                ON staff.job_title_id = job_title.job_title_id
                LEFT JOIN department
                ON staff.department_id = department.department_id
                LEFT JOIN job_grade
                ON staff.job_grade_id = job_grade.job_grade_id
                WHERE job_title.job_title_id = ?
                GROUP BY job_title.title
                """;
        var rowMapper = BeanPropertyRowMapper.newInstance(Staff.class);
        return jdbcTemplate.query(sql, rowMapper, jobTitleId).stream()
                .map(StaffDTOMapper::toStaffDepartmentResponse)
                .toList();
    }

    @Override
    public List<StaffNextOfKinDTO> retrieveStaffNextOfKin(Integer staffId) {
        var sql = """
                SELECT *
                FROM next_of_kin
                WHERE next_of_kin.staff_id = ?
                """;

        return jdbcTemplate.query(sql, mapper,staffId)
                .stream()
                .map(StaffDTOMapper::toNextOfKinDTO)
                .toList();
    }
}


