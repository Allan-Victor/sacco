package org.sacco.hr.model;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class JobGrade {
    private Integer jobGradeId;
    private String grade;
}