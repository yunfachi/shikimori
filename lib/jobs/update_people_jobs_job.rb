class UpdatePeopleJobsJob
  def perform
    Person.transaction do
      Person.update_all producer: false, mangaka: false, seyu: false

      Person.where(id: producer_ids).update_all producer: true
      Person.where(id: mangaka_ids).update_all mangaka: true
      Person.where(id: seyu_ids).update_all seyu: true
    end
  end

  def producer_ids
    PersonRole
      .where {
        ( role.like 'Chief Producer' ) |
        ( role.like 'Chief Producer,%' ) |
        ( role.like '%, Chief Producer' ) |
        ( role.like '%, Chief Producer,%' ) |
        ( role.like 'Director' ) |
        ( role.like 'Director,%' ) |
        ( role.like '%, Director' ) |
        ( role.like '%, Director,%' )
      }
      .pluck(:person_id)
      .uniq
  end

  def mangaka_ids
    PersonRole
      .where(role: Person::MangakaRoles)
      .pluck(:person_id)
      .uniq
  end

  def seyu_ids
    PersonRole
      .where(role: Person::SeyuRoles)
      .pluck(:person_id)
      .uniq
  end
end
