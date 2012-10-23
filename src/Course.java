import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

/** Учебный курс */
@XmlType(name="course")
public class Course {

    private String name;

    private Instructor instructor;

    @XmlAttribute(name="id")
    private String id;

    /** Название */
    public String getName() {
        return name;
    }

    @XmlElement(name="name")
    public void setName(String name) {
        this.name = name;
    }

    /** Преподаватель */
    public Instructor getInstructor() {
        return instructor;
    }

    /** Имя преподавателя */
    public String getInstructorName() {
        if (instructor == null) {
            return null; // Анонимус!
        }

        return instructor.getName();
    }

    @XmlElement(name="prof")
    public void setInstructor(Instructor instructor) {
        this.instructor = instructor;
    }

    public String getId() {
        return id;
    }
}
