import { executeSaimaltorAction } from '../src/services/saimaltorAPI';

async function main() {
  const result = await executeSaimaltorAction('saimaltor:renew-passport', {
    user: { name: 'أحمد', saudiId: '1029384756' }
  });

  console.log('--- Saimaltor Renew Passport Result ---');
  console.log(JSON.stringify(result, null, 2));
}

main().catch((err) => {
  console.error('Harness error', err);
  process.exit(1);
});
