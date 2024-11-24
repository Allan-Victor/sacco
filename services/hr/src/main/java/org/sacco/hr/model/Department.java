package org.sacco.hr.model;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class Department {
    private Integer departmentId;
    private String departmentName;
    private String managerName;

}
