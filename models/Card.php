<?php

namespace app\models;

use yii\db\ActiveQuery;

class Card extends User {
	/**
	 * {@inheritDoc}
	 */
	public function fields() {
		return [
			'user_id' => 'id',
			'age',
			'gender',
			'lookfor'
		];
	}

	/**
	 * {@inheritDoc}
	 */
	public static function tableName() {
		return 'users';
	}

	/**
	 * Getter for lookfor property
	 *
	 * @return array
	 */
	public function getLookfor() {
		return [
			'gender' => $this->lookfor_gender,
			'age_from' => $this->lookfor_age_from,
			'age_to' => $this->lookfor_age_to,
		];
	}

	/**
	 * Find candidates for voting.
	 *
	 * @param User $user
	 * @return ActiveQuery
	 */
	public static function findCandidatesFor(User $user) {
		return self::find()
			->where('id <> :voter')
			->andWhere('gender=:gender')
			->andWhere('age between :age_from and :age_to')
			->andWhere('id not in (select candidate_user_id from votes where user_id = :voter)')
			->addParams([
				':voter' => $user->getId(),
				':gender' => $user->lookfor_gender,
				':age_from' => $user->lookfor_age_from,
				':age_to' => $user->lookfor_age_to,
			]);
	}
}
