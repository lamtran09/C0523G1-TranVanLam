package extra_exercises.service;

import extra_exercises.model.ForeignerPeople;
import extra_exercises.model.VietNamPeople;
import extra_exercises.repository.ForeignerPeopleRepository;
import extra_exercises.repository.IPersonRepository;

import java.util.List;
import java.util.Scanner;

import static extra_exercises.view.Main.scanner;

public class ForeignerPeopleService implements IPersonService{
    private final Scanner scanner = new Scanner(System.in);
    private final IPersonRepository<ForeignerPeople> foreignerPeopleIPersonRepository = new ForeignerPeopleRepository();
    @Override
    public void read() {
        List<ForeignerPeople> foreignerPeople = foreignerPeopleIPersonRepository.display();
        for (ForeignerPeople people:foreignerPeople) {
            System.out.println(people);
        }
    }

    @Override
    public void create() {
        System.out.println("Nhâp mã khách hàng");
        String codePerson = scanner.nextLine();
        System.out.println("Nhập tên khách hàng");
        String namePerson = scanner.nextLine();
        System.out.println("Nhập quốc tịch khách hàng");
        String nationality = scanner.nextLine();
        ForeignerPeople foreignerPeople = new ForeignerPeople(codePerson,namePerson,nationality);
        foreignerPeopleIPersonRepository.add(foreignerPeople);
    }

    @Override
    public void search() {
        System.out.println("Nhập mã khách hàng mà bạn muốn tìm kiếm");
        String code = scanner.nextLine();
        ForeignerPeople foreignerPeople = foreignerPeopleIPersonRepository.getByID(code);
        if(foreignerPeople == null){
            System.out.println("Không tìm thấy khách hàng");
        }else {
            System.out.println(foreignerPeople);
        }
    }
}
