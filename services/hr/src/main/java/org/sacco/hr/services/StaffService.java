package org.sacco.hr.services;

import lombok.RequiredArgsConstructor;
import org.sacco.hr.dao.StaffDao;
import org.sacco.hr.dto.StaffDepartmentOrderDTO;
import org.sacco.hr.dto.StaffNextOfKinDTO;
import org.sacco.hr.dto.StaffResponseDTO;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class StaffService {

    private final StaffDao staffDao;

    public List<StaffDepartmentOrderDTO> fetchStaffListOrderedByDepartment() {
        return staffDao.retrieveStaffByDepartmentOrder();
    }

    public List<StaffResponseDTO> fetchStaffDepartmentList(Integer departmentId) {
       return staffDao.retrieveStaffDepartmentList(departmentId);
    }

    public List<StaffResponseDTO> fetchStaffPositionList(Integer jobTitleId) {
        return staffDao.retrieveStaffPositionList(jobTitleId);
    }

    public List<StaffNextOfKinDTO> fetchStaffNextOfKin(Integer staffId) {
        return staffDao.retrieveStaffNextOfKin(staffId);
    }
}
